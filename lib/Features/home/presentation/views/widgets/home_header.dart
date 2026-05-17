import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        context.l10n.homeBrandName,
        style: AppTheme.getTextStyle(
          fontFamily: 'IMFellEnglish',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.mainColor,
        ),
      ),
    );
  }
}
