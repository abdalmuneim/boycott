import 'package:boycott_pro/features/scan/presentations/scan_controller.dart';
import 'package:boycott_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Utils {
  /// SUCCESS NOTIFICATION
  static showSuccess(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.rawSnackbar(
      message: message.tr,
      barBlur: 5,
      maxWidth: Get.width,

      snackPosition: SnackPosition.BOTTOM,
      // backgroundColor: ColorManager.green.withOpacity(0.7),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    );
  }

  /// ERROR NOTIFICATION
  static showError(String message) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.rawSnackbar(
      message: message,
      barBlur: 5,
      maxWidth: Get.width,
      backgroundColor: Colors.red,

      snackPosition: SnackPosition.BOTTOM,
      // backgroundColor: ColorManager.red.withOpacity(0.7),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    );
  }

  static Future canPayPro({
    required String gif,
    required String title,
  }) =>
      showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: Lottie.asset(gif),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ScanController.to.showAd();
                  Get.back(result: true);
                },
                child: Text(
                  S.of(context).cancel,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
}
