import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key, this.userEmail});

  final String? userEmail;

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final email = widget.userEmail ?? '';
      if (widget.userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.emailRequired),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }
      context.read<ForgetPasswordViewModel>().doIntent(
        ResetPassword(newPassword: _newPassword.text.trim(), email: email),
      );
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        final resetPasswordState = state.resetPasswordState;

        if (resetPasswordState?.data != null &&
            resetPasswordState?.isLoading == false) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(context.l10n.success),
              content: Text(context.l10n.resetSuccessfully),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(context.l10n.ok),
                ),
              ],
            ),
          );
        } else if (resetPasswordState?.errorMessage != null &&
            resetPasswordState?.isLoading == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resetPasswordState!.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.resetPasswordState?.isLoading ?? false;

        return Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            children: [
              TextFormField(
                key: const Key('newPasswordField'),
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) =>
                    FormValidators.validatePassword(context, value),
                controller: _newPassword,
                obscureText: !_isNewPasswordVisible,
                enabled: !isLoading,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                    icon: _isNewPasswordVisible
                        ? const Icon(Icons.visibility, color: AppColors.gray)
                        : const Icon(
                            Icons.visibility_off,
                            color: AppColors.gray,
                          ),
                  ),
                  labelText: context.l10n.newPasswordLabel,
                  hintText: context.l10n.passwordHint,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                key: const Key('confirmPasswordField'),
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) => FormValidators.validateConfirmPassword(
                  context,
                  value,
                  _newPassword.text.trim(),
                ),
                controller: _confirmPassword,
                obscureText: !_isConfirmPasswordVisible,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: context.l10n.confirmPasswordLabel,
                  hintText: context.l10n.confirmPasswordHint,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    icon: _isConfirmPasswordVisible
                        ? const Icon(Icons.visibility, color: AppColors.gray)
                        : const Icon(
                            Icons.visibility_off,
                            color: AppColors.gray,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSubmit,
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(context.l10n.confirmButton),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
