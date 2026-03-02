import 'package:lottie/lottie.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/core/widget/custom_button.dart';
import 'package:tracking_app/gen/assets.gen.dart';

class SuccessApplyScreen extends StatelessWidget {
  const SuccessApplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                child: Lottie.asset(
                  repeat: false,
                  height: MediaQuery.of(context).size.height * 0.35,
                  key: Key("successApplyLottie"),
                  Assets.lottie.checkAnimation,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      key: Key("successApplySubTitle"),
                      context.l10n.successApplySubTitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Text(
                      key: Key("successApplyDescription"),
                      context.l10n.successApplyDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 30,
                vertical: 25,
              ),
              key: Key("loginSuccessApply"),
              child: CustomButton(
                title: context.l10n.loginTitle,
                onPressed: () {
                  context.goNamed(Routes.loginName);
                },
              ),
            ),
            Expanded(
              child: Assets.images.bg.image(
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
