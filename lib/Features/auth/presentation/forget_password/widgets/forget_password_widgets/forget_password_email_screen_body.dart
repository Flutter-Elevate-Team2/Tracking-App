import 'package:flutter/material.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/forget_password_widgets/email_form_section.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/shared/custom_text_section.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class ForgetPasswordEmailScreenBody extends StatelessWidget {
  const ForgetPasswordEmailScreenBody({
    super.key,
    required this.onNextPage,
    this.onEmailSubmitted,
  });

  final VoidCallback onNextPage;
  final void Function(String email)? onEmailSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          TextSection(
            title: context.l10n.forgotPasswordTitle,
            subTitle: context.l10n.forgotPasswordSubTitle,
          ),
          const SizedBox(height: 32),
          EmailFormSection(
            onNextPage: onNextPage,
            onEmailSubmitted: onEmailSubmitted,
          ),
        ],
      ),
    );
  }
}
