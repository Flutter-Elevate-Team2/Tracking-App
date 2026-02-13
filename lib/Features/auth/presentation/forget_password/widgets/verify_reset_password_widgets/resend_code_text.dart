import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class ResendCodeText extends StatelessWidget {
  final String? email;
  final bool isLoading;

  const ResendCodeText({super.key, this.email, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.resendCode,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton(
                onPressed: () {
                  context.read<ForgetPasswordViewModel>().doIntent(
                    SendOtp(email: email ?? ''),
                  );
                },
                child: Text(
                  context.l10n.resend,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
      ],
    );
  }
}
