import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:boycott_pro/common/utils/interstitial_ad.dart';
import 'package:boycott_pro/common/utils/utils.dart';
import 'package:boycott_pro/common/utils/widgets/dialog_search.dart';
import 'package:boycott_pro/features/scan/models/split_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController with WidgetsBindingObserver {
  static ScanController get to => Get.find();
  bool _isPermissionGranted = false;
  bool get isPermissionGranted => _isPermissionGranted;

  late Future<void> _future;
  Future<void> get future => _future;

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  final AdInterstitialWid _adMob = AdInterstitialWid.instance;
  AdInterstitialWid get adMob => _adMob;

  final TextRecognizer _textRecognizer = TextRecognizer();
  TextRecognizer get textRecognizer => _textRecognizer;

  bool _checked = false;
  bool get checked => _checked;
  bool _scanning = false;
  bool get scanning => _scanning;

  final TextEditingController _text = TextEditingController();
  TextEditingController get text => _text;

  // ignore: unused_field
  late Timer _timer;

  Future<bool> searchWordInJson(String recognizedWord) async {
    final String jsonContent =
        await rootBundle.loadString('assets/text_en.json');

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

  Future<void> scanImage() async {
    if (_cameraController == null) return;
    _scanning = true;
    update();
    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      _text.text = recognizedText.text.replaceAll(' ', '').replaceAll('\n', '');

      _checked = await searchWordInJson(_text.text.toLowerCase());
      _scanning = false;

      update();
      if (_checked) {
        Utils.canPayPro(
            product: _text.text,
            gif: 'assets/no.json',
            title: 'هذا المنتج اسرائيلي يجب مقاطعته');
      } else {
        DialogSearch.showEditValue(_checked);
      }
    } catch (e) {
      _scanning = false;
      update();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء مسح النص ضوئيًا'),
        ),
      );
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
    update();
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

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.auto);

    update();
  }

  void initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // check permission get available cameras here and remove future builder

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

  _showAd() {
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (computationCount) {
        adMob.loadAdInterstitial();
      },
    );
  }

  @override
  void onInit() async {
    _future = requestCameraPermission();
    _showAd();
    update();
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
      _timer.cancel();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
      _showAd();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _timer.cancel();
    textRecognizer.close();
    super.dispose();
  }
}
