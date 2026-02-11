import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class PasswordRow extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback togglePasswordVisibility;
  final VoidCallback toggleConfirmPasswordVisibility;
  final GlobalKey<FormState> formKey;

  const PasswordRow({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.togglePasswordVisibility,
    required this.toggleConfirmPasswordVisibility,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            textInputAction: TextInputAction.next,
            controller: passwordController,
            obscureText: !isPasswordVisible,
            style: Theme.of(context).textTheme.bodySmall,
            validator: (value) =>
                FormValidators.validatePassword(context, value),
            onChanged: (_) {
              if (confirmPasswordController.text.isNotEmpty) {
                formKey.currentState?.validate();
              }
            },
            decoration: InputDecoration(
              labelText: (context).l10n.passwordLabel,
              hintText: (context).l10n.passwordHint,
              helperText: "",
              suffixIcon: passwordController.text.isNotEmpty
                  ? IconButton(
                      onPressed: togglePasswordVisibility,
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.gray,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            textInputAction: TextInputAction.next,
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            style: Theme.of(context).textTheme.bodySmall,
            validator: (value) => FormValidators.validateConfirmPassword(
              context,
              value,
              passwordController.text,
            ),
            decoration: InputDecoration(
              labelText: (context).l10n.confirmPasswordLabel,
              hintText: (context).l10n.confirmPasswordHint,
              helperText: "",
              suffixIcon: passwordController.text.isNotEmpty
                  ? IconButton(
                      onPressed: toggleConfirmPasswordVisibility,
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.gray,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
