import 'package:flutter/material.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_screen_body.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.onPreviousPage,
    this.userEmail,
  });

  final VoidCallback onPreviousPage;
  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
          onPressed: onPreviousPage,
        ),
        title: Text(context.l10n.passwordLabel),
      ),
      body: ResetPasswordScreenBody(userEmail: userEmail),
    );
  }
}
