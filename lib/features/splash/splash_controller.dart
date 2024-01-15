import 'package:boycott_pro/features/scan/presentations/scan_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  nav() {
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAll(() => const ScanPage()),
    );
  }

  @override
  void onInit() {
    nav();
    super.onInit();
  }
}
