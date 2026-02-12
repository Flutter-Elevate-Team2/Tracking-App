import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/widget/custom_button.dart';
import 'package:tracking_app/gen/assets.gen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Transform.translate(
                  offset: Offset(-screenWidth * 0.45, 0),
                  child: Lottie.asset(
                    key: Key("onBoardingLottie"),
                    height: MediaQuery.of(context).size.height * 0.45,
                    Assets.lottie.deliveryServiceDeliveryMan,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key: Key("welcomeTo"),
                        context.l10n.welcomeTo,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        key: Key("floweryRiderApp"),
                        context.l10n.floweryRiderApp,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                key: Key("loginButtonOnBoarding"),
                child: CustomButton(
                  title: context.l10n.loginTitle,
                  onPressed: () {
                    context.goNamed(Routes.loginName);
                  },
                ),
              ),

              SizedBox(
                key: Key("applyButtonOnBoarding"),
                width: double.infinity,
                child: CustomButton(
                  title: context.l10n.applyButton,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context.goNamed(Routes.applyName);
                  },
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.gray,
                ),
              ),
              Spacer(),
              Text(
                key: Key("versionOnBoarding"),
                context.l10n.appVersion,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.gray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
