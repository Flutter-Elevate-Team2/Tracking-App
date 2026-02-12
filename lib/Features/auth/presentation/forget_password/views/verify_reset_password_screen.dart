import 'package:flutter/material.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/verify_reset_password_screen_body.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class VerifyResetPasswordScreen extends StatelessWidget {
  const VerifyResetPasswordScreen({
    super.key,
    required this.onPreviousPage,
    required this.onNextPage,
    this.email,
    this.errorMessage,
  });

  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final String? email;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,

        titleSpacing: 0,
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
          onPressed: onPreviousPage,
        ),
        title: Text(context.l10n.passwordLabel),
      ),
      body: VerifyResetPasswordScreenBody(
        onNextPage: onNextPage,
        errorMessage: errorMessage,
        email: email,
      ),
    );
  }
}
