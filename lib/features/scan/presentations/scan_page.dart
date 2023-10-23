import 'package:boycott_pro/common/utils/banner_ad.dart';
import 'package:boycott_pro/features/scan/presentations/scan_controller.dart';

import 'package:camera/camera.dart';
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
                title: const Text('فحص المنتج'),
                centerTitle: true,
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
                              return CameraPreview(
                                  controller.cameraController!);
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
                                      MediaQuery.of(context).size.height / 9,
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
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.document_scanner_outlined),
                                          SizedBox(width: 8),
                                          Text(
                                            'مسح النص',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : Positioned(
                              bottom: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'تم رفض إذن الكاميرا \nيجب تفعيل اذن الكاميرا',
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          controller.requestCameraPermission(),
                                      child: const Text('أضغط للتفعيل'))
                                ],
                              ),
                            ),
                      const Positioned(bottom: 0, child: AdBannerWidget()),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}
