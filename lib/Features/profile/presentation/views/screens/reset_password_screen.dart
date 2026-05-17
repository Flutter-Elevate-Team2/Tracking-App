import 'package:flutter/material.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/reset_password_screen_body.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(context.l10n.resetPasswordTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ResetPasswordScreenBody(),
    );
  }
}