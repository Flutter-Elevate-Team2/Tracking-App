import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/shared/custom_text_section.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/otp_input_widget.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/resend_code_text.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class VerifyResetPasswordScreenBody extends StatelessWidget {
  const VerifyResetPasswordScreenBody({
    super.key,
    required this.onNextPage,
    this.email,
    this.errorMessage,
  });

  final VoidCallback onNextPage;
  final String? email;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        if (state.verifyOtpState?.data != null &&
            state.verifyOtpState?.isLoading == false) {
          onNextPage();
        }
      },
      builder: (context, state) {
        final isVerifyLoading = state.verifyOtpState?.isLoading ?? false;
        final isResendLoading = state.sendOtpState?.isLoading ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextSection(
                title: context.l10n.verificationTitle,
                subTitle: context.l10n.verificationSubTitle,
              ),
              const SizedBox(height: 32),
              OtpInputWidget(
                length: 6,
                errorText: state.verifyOtpState?.errorMessage,
                onCompleted: (value) {
                  if (!isVerifyLoading) {
                    context.read<ForgetPasswordViewModel>().doIntent(
                      VerifyOtp(otp: value),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
              if (isVerifyLoading)
                const CircularProgressIndicator()
              else
                ResendCodeText(email: email, isLoading: isResendLoading),
            ],
          ),
        );
      },
    );
  }
}
