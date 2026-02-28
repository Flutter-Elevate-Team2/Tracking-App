import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/widget/custom_button.dart';

class LoginSubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback onPressed;

  const LoginSubmitButton({
    super.key,
    required this.isLoading,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 24),
        child: CircularProgressIndicator(),
      );
    }

    return CustomButton(
      key: Key('loginButton'),
      title: context.l10n.continueButton,
      onPressed: enabled ? onPressed : null,
      backgroundColor: AppColors.mainColor,
      disabledBackgroundColor: AppColors.black[30],
    );
  }
}
