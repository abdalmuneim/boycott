import 'package:boycott_pro/features/splash/splash_controller.dart';
import 'package:boycott_pro/generated/assets/assets.dart';
import 'package:boycott_pro/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
              body: SafeArea(
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Container(
                        // width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: const AssetImage(
                                Assets.assetsImagesPalesrine,
                              ),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.dstATop)),
                        ),
                        child: Wrap(
                            verticalDirection: VerticalDirection.down,
                            direction: Axis.vertical,
                            spacing: 1,
                            runSpacing: 3,
                            children: List.generate(
                              100.h.toInt(),
                              (index) => Text(
                                S.of(context).freedomForPalestine,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.1),
                                ),
                              ),
                            ).toList()),
                      ),
                    ),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.asset(
                            Assets.assetsImagesBoycott,
                            width: 70.w,
                          ),
                          Positioned(
                            bottom: 20,
                            child: Text(
                              S.of(context).israeli,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
        });
  }
}
