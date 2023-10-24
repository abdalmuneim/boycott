import 'package:boycott_pro/features/scan/presentations/scan_controller.dart';
import 'package:boycott_pro/generated/l10n.dart';

import 'package:camera/camera.dart';
import 'package:firebase_admob_config/firebase_admob_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScanController>(
        init: ScanController(),
        builder: (ScanController controller) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).scanProduct),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () => controller.newProducts(),
                      icon: const Icon(Icons.production_quantity_limits))
                ],
              ),
              body: FutureBuilder(
                future: controller.future,
                builder: (context, snapshot) {
                  return Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (controller.isPermissionGranted)
                        FutureBuilder<List<CameraDescription>>(
                          future: availableCameras(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              controller.initCameraController(snapshot.data!);
                              return controller.isDispose
                                  ? Container()
                                  : CameraPreview(controller.cameraController!);
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      controller.isPermissionGranted
                          ? controller.scanning
                              ? Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height / 9,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height / 8.5,
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: controller.scanImage,
                                      style: const ButtonStyle(
                                        textStyle: MaterialStatePropertyAll(
                                          TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                              Icons.document_scanner_outlined),
                                          const SizedBox(width: 8),
                                          Text(
                                            S.of(context).scanText,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : Positioned(
                              bottom: MediaQuery.of(context).size.height / 2.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).requestPermission,
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          controller.requestCameraPermission(),
                                      child: Text(S.of(context).clickToEnable))
                                ],
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        child: FutureBuilder(
                          future: Future.delayed(
                              const Duration(seconds: 5), () => true),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return AppBannerAd.fromKey(
                                  configKey: 'banner_ad');
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}
