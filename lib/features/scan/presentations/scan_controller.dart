import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:boycott_pro/common/utils/utils.dart';
import 'package:boycott_pro/common/utils/widgets/check_update.dart';
import 'package:boycott_pro/common/utils/widgets/dialog_search.dart';
import 'package:boycott_pro/features/scan/models/split_model.dart';
import 'package:boycott_pro/generated/assets/assets.dart';
import 'package:boycott_pro/generated/l10n.dart';
import 'package:camera/camera.dart';
import 'package:firebase_admob_config/firebase_admob_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController with WidgetsBindingObserver {
  static ScanController get to => Get.find();
  InAppUpdate? inAppUpdate;

  bool _isPermissionGranted = false;
  bool get isPermissionGranted => _isPermissionGranted;

  late Future<void> _future;
  Future<void> get future => _future;

  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  final TextRecognizer _textRecognizer = TextRecognizer();
  TextRecognizer get textRecognizer => _textRecognizer;

  bool _checked = false;
  bool get checked => _checked;
  bool _scanning = false;
  bool get scanning => _scanning;
  bool _isDispose = false;
  bool get isDispose => _isDispose;
  bool _sending = false;
  bool get sending => _sending;

  final GlobalKey<FormState> _globalKey = GlobalKey();
  GlobalKey<FormState> get globalKey => _globalKey;
  final TextEditingController _text = TextEditingController();
  TextEditingController get text => _text;
  final TextEditingController _productName = TextEditingController();
  TextEditingController get productName => _productName;

  // ignore: unused_field
  late Timer _timer;
  List<dynamic> _products = [];

  _getProduct() async {
    final String jsonContent =
        await rootBundle.loadString('assets/text_en.json');
    _products = json.decode(jsonContent);
    update();
  }

  Future<bool> searchWordInJson(String recognizedWord) async {
    List<SplitResult> splitResults = [
      SplitResult('', recognizedWord.toLowerCase())
    ];

    for (var splitItem in _products) {
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
      final XFile pictureFile = await _cameraController!.takePicture();

      final File file = File(pictureFile.path);

      final InputImage inputImage = InputImage.fromFile(file);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      _text.text = recognizedText.text.replaceAll(' ', '').replaceAll('\n', '');

      _checked = await searchWordInJson(_text.text.toLowerCase());
      _scanning = false;
      update();

      if (_checked) {
        Utils.canPayPro(
            gif: Assets.assetsNo,
            title: S.of(Get.context!).boycottThisProduct(_text.text));
      } else {
        _stopCamera();
        bool search =
            await DialogSearchAndAddNewProduct.showEditValue(_checked);

        search ? _startCamera() : null;
      }
    } catch (e) {
      _startCamera();
      _scanning = false;
      update();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(S.of(Get.context!).anErrorOccurredWhileScanningText),
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
      _isDispose = false;
      update();
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
      _isDispose = true;
      update();
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

  final AppInterstitialAd interstitialAd =
      AppInterstitialAd.fromKey(configKey: 'interstitial_ad');

  _showAd() {
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (computationCount) {
        interstitialAd.run();
      },
    );
  }

  newProducts() {
    DialogSearchAndAddNewProduct.newProductsDialog();
  }

  changeSend() {
    _sending = !_sending;
    update();
  }

  @override
  void onInit() async {
    _future = requestCameraPermission();
    _getProduct();
    _showAd();
    CheckUpdate.instance.checkForUpdates();
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
