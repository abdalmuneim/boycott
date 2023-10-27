import 'package:boycott_pro/common/services/notification_service.dart';
import 'package:boycott_pro/common/utils/utils.dart';
import 'package:boycott_pro/features/scan/presentations/scan_controller.dart';
import 'package:boycott_pro/features/scan/data/remote_data_source/scan_remote_data_source.dart';
import 'package:boycott_pro/generated/assets/assets.dart';
import 'package:boycott_pro/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogSearchAndAddNewProduct {
  static newProductsDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => GetBuilder<ScanController>(builder: (controller) {
        return AlertDialog(
          scrollable: true,
          title: Text(S.of(context).boycottProduct),
          content: Form(
              key: controller.globalKey,
              child: TextFormField(
                controller: controller.productName,
                validator: (value) => (value == null || value.isEmpty)
                    ? S.of(context).thisFieldRequired
                    : null,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(S.of(context).cancel),
            ),
            controller.sending
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.blueAccent,
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      if (controller.globalKey.currentState!.validate()) {
                        controller.changeSend();
                        NotificationServiceImpl notificationFirebaseImpl =
                            NotificationServiceImpl();
                        await ScanRemoteDataSource()
                            .newProducts(
                                controller.productName.text,
                                await notificationFirebaseImpl.getFCMToken() ??
                                    "")
                            .then((DocumentReference<Map<String, dynamic>>
                                value) {
                          controller.changeSend();
                          Get.back();
                          Utils.showSuccess(S.of(context).successSend);
                          controller.productName.clear();
                        }).catchError(
                          (e) {
                            controller.changeSend();
                            Utils.showError(S.of(context).someThingHappened);
                          },
                        );
                      }
                    },
                    child: Text(S.of(context).send),
                  ),
          ],
        );
      }),
    );
  }

  static Future showEditValue(bool checked) => showDialog(
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
                  decoration: InputDecoration(
                    labelText: S.of(context).edit,
                  ),
                ),
              ],
            ),
            title: Text(
              S.of(context).isThisTheProductName(''),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  S.of(context).cancel,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueAccent)),
                onPressed: () async {
                  if (Navigator.canPop(context)) {
                    Get.back(result: true);
                  }
                  checked = await ScanController.to.searchWordInJson(
                      ScanController.to.text.text.toLowerCase());

                  if (checked) {
                    Utils.canPayPro(
                        gif: Assets.assetsNo,
                        title: S
                            .of(Get.context!)
                            .boycottThisProduct(ScanController.to.text.text));
                  } else {
                    Utils.canPayPro(
                        gif: Assets.assetsOk,
                        title: S.of(Get.context!).thisProductIsVeryGood(
                            ScanController.to.text.text));
                  }
                },
                child: Text(
                  S.of(context).yes,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
}
