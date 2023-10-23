import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Utils {
  static canPayPro(
          {required String gif,
          required String title,
          required String product}) =>
      showDialog(
        barrierDismissible: false,
        context: Get.context!,
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
}
