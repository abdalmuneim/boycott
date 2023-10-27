import 'package:boycott_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class CheckUpdate {
  static CheckUpdate get instance => _init;
  static final CheckUpdate _init = CheckUpdate();
  Future<void> checkForUpdates() async {
    // checkForUpdate
    final AppUpdateInfo updateStatus = await InAppUpdate.checkForUpdate();

    if (updateStatus.updateAvailability == UpdateAvailability.updateAvailable) {
      // A new update is available. Notify the user and prompt for an update.
      showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text(S.of(context).updateAvailable),
          content: Text(S.of(context).aNewVersionOfTheAppIsAvailableDoYou),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).updateNow),
              onPressed: () async {
                // Start the update process
                await InAppUpdate.performImmediateUpdate();
              },
            ),
            TextButton(
              child: Text(S.of(context).updateLater),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }
}
