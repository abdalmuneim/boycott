import 'package:boycott_pro/common/utils/utils.dart';
import 'package:boycott_pro/features/scan/presentations/scan_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogSearch {
  static showEditValue(bool checked) => showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: ScanController.to.text,
                  decoration: const InputDecoration(
                    labelText: 'تعديل',
                  ),
                ),
              ],
            ),
            title: Text(
              'هل هذا ${ScanController.to.text.text} اسم المنتج',
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
                  checked = await ScanController.to.searchWordInJson(
                      ScanController.to.text.text.toLowerCase());

                  if (checked) {
                    Utils.canPayPro(
                        product: ScanController.to.text.text,
                        gif: 'assets/no.json',
                        title: 'هذا المنتج اسرائيلي يجب مقاطعته');
                  } else {
                    Utils.canPayPro(
                        product: ScanController.to.text.text,
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
