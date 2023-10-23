import 'dart:convert';
import 'dart:io';

import 'package:boycott_pro/split_nodel.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Recognition Flutter',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      locale: Get.deviceLocale,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return CameraPreview(_cameraController!);
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('فحص المنتج'),
                centerTitle: true,
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _scanImage,
                              child: const Text('أمسح النص'),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          'تم رفض إذن الكاميرا \nيجب تفعيل اذن الكاميرا',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<bool> _searchWordInJson(String recognizedWord) async {
    final String jsonContent = await rootBundle.loadString(
        Get.locale?.languageCode != 'ar'
            ? 'assets/text_en.json'
            : 'assets/text_ar.json');

    final List<dynamic> data = json.decode(jsonContent);
    List<SplitResult> splitResults = [
      SplitResult('', recognizedWord.toLowerCase())
    ];

    for (var splitItem in data) {
      List<SplitResult> newSplitResults = [];

      for (SplitResult result in splitResults) {
        List<String> textParts = result.splitText
            .split(splitItem['text'].replaceAll(' ', '').toLowerCase());
        for (String part in textParts) {
          newSplitResults
              .add(SplitResult(splitItem['text'].toLowerCase(), part));
        }
        if (newSplitResults.length >= 2) {
          _text.text = splitItem['text'];
          return true;
        }
      }
      splitResults = newSplitResults;
    }
    return false;
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      _text.text = recognizedText.text.replaceAll(' ', '').replaceAll('\n', '');
      print('_text.text: ${_text.text}');
      _checked = await _searchWordInJson(_text.text.toLowerCase());
      print('_text.text: ${_text.text}');
      setState(() {});
      if (_checked) {
        _canPayPro(
            product: _text.text,
            gif: 'assets/no.json',
            title: 'هذا المنتج اسرائيلي يجب مقاطعته');
      } else {
        Navigator.canPop(context) ? Navigator.of(context).pop() : null;
        _showEditValue();
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء مسح النص ضوئيًا'),
        ),
      );
    }
  }

  _canPayPro(
          {required String gif,
          required String title,
          required String product}) =>
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Lottie.asset(gif),
            title: Text(
              '$product $title',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'غلق',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        },
      );

  final _text = TextEditingController();
  _showEditValue() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _text,
                  decoration: const InputDecoration(
                    labelText: 'تعديل',
                  ),
                ),
              ],
            ),
            title: Text(
              'هل هذا ${_text.text} اسم المنتج',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'غلق',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  _checked = await _searchWordInJson(_text.text.toLowerCase());

                  if (_checked) {
                    _canPayPro(
                        product: _text.text,
                        gif: 'assets/no.json',
                        title: 'هذا المنتج اسرائيلي يجب مقاطعته');
                  } else {
                    _canPayPro(
                        product: _text.text,
                        gif: 'assets/ok.json',
                        title: 'يمكنك شراء هذا المنتج انه نظيف');
                  }
                },
                child: const Text(
                  'نعم',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
}
