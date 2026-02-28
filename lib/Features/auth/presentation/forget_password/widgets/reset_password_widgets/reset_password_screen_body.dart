import 'package:flutter/material.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_form.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/shared/custom_text_section.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class ResetPasswordScreenBody extends StatelessWidget {
  const ResetPasswordScreenBody({super.key, this.userEmail});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          TextSection(
            title: context.l10n.resetPasswordTitle,
            subTitle: context.l10n.resetPasswordSubTitle,
          ),
          const SizedBox(height: 32),
          ResetPasswordForm(userEmail: userEmail),
        ],
      ),
    );
  }
}
