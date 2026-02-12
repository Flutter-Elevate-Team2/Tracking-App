import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/change_password/change_password_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/change_password/change_password_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_text_form_field.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class ResetPasswordScreenBody extends StatefulWidget {
  const ResetPasswordScreenBody({super.key});

  @override
  State<ResetPasswordScreenBody> createState() =>
      _ResetPasswordScreenBodyState();
}

class _ResetPasswordScreenBodyState extends State<ResetPasswordScreenBody> {
  late TextEditingController currentPasswordController =
      TextEditingController();
  late TextEditingController newPasswordController = TextEditingController();
  late TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    currentPasswordController.addListener(_updateButtonState);
    newPasswordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          currentPasswordController.text.isNotEmpty &&
          newPasswordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordViewModel, ChangePasswordStates>(
      listenWhen: (previous, current) {
        return previous.changePasswordState != current.changePasswordState;
      },
      listener: (context, state) {
        final changePassState = state.changePasswordState;

        // Skip loading state — handled by builder
        if (changePassState?.isLoading ?? false) return;

        if (changePassState?.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.passwordChangedSuccess),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (changePassState?.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(changePassState!.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      buildWhen: (previous, current) {
        return previous.changePasswordState != current.changePasswordState;
      },
      builder: (context, state) {
        final isLoading = state.changePasswordState?.isLoading ?? false;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Column(
                children: [
                  SizedBox(height: 32),
                  ProfileTextField(
                    validator: (value) =>
                        FormValidators.validatePassword(context, value),
                    controller: currentPasswordController,
                    label: context.l10n.currentPasswordLabel,
                    hintText: context.l10n.currentPasswordHint,
                    trailing: _obscureCurrentPassword
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureCurrentPassword =
                                    !_obscureCurrentPassword;
                              });
                            },
                            icon: Icon(Icons.visibility_off_outlined),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureCurrentPassword =
                                    !_obscureCurrentPassword;
                              });
                            },
                            icon: Icon(Icons.visibility_outlined),
                          ),
                    isObscure: _obscureCurrentPassword,
                  ),
                  SizedBox(height: 24),
                  ProfileTextField(
                    validator: (value) =>
                        FormValidators.validatePassword(context, value),
                    controller: newPasswordController,
                    label: context.l10n.newPasswordLabel,
                    hintText: context.l10n.newPasswordLabel,
                    trailing: _obscureNewPassword
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                            icon: Icon(Icons.visibility_off_outlined),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                            icon: Icon(Icons.visibility_outlined),
                          ),
                    isObscure: _obscureNewPassword,
                  ),
                  SizedBox(height: 24),
                  ProfileTextField(
                    validator: (value) =>
                        FormValidators.validateConfirmPassword(
                          context,
                          value,
                          newPasswordController.text,
                        ),
                    controller: confirmPasswordController,
                    label: context.l10n.confirmPasswordLabel,
                    hintText: context.l10n.confirmPasswordHint,
                    trailing: _obscureConfirmPassword
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(Icons.visibility_off_outlined),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(Icons.visibility_outlined),
                          ),
                    isObscure: _obscureConfirmPassword,
                  ),

                  SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: (_isButtonEnabled && !isLoading)
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<ChangePasswordViewModel>()
                                    .doIntent(
                                      ChangePasswordEvent(
                                        request: ChangePasswordRequest(
                                          password:
                                              currentPasswordController.text,
                                          newPassword:
                                              newPasswordController.text,
                                        ),
                                      ),
                                    );
                                setState(() {
                                  _autovalidateMode = AutovalidateMode.always;
                                });
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey,
                        disabledForegroundColor: Colors.white,
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(context.l10n.update),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
