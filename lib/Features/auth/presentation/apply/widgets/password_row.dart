import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class PasswordRow extends StatefulWidget {
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
  State<PasswordRow> createState() => _PasswordRowState();
}

class _PasswordRowState extends State<PasswordRow> {

  @override
  void initState() {
    super.initState();
    // بنخلي الحقول تسمع لأي تغيير في النص عشان تظهر/تخفي العين لحظياً
    widget.passwordController.addListener(_updateState);
    widget.confirmPasswordController.addListener(_updateState);
  }

  @override
  void dispose() {
    // مهم جداً نشيل الـ listeners لما الويدجيت تتمسح
    widget.passwordController.removeListener(_updateState);
    widget.confirmPasswordController.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            textInputAction: TextInputAction.next,
            controller: widget.passwordController,
            obscureText: !widget.isPasswordVisible,
            style: Theme.of(context).textTheme.bodySmall,
            validator: (value) =>
                FormValidators.validatePassword(context, value),
            onChanged: (_) {
              if (widget.confirmPasswordController.text.isNotEmpty) {
                widget.formKey.currentState?.validate();
              }
            },
            decoration: InputDecoration(
              labelText: context.l10n.passwordLabel,
              hintText: context.l10n.passwordHint,
              helperText: "",
              suffixIcon: widget.passwordController.text.isNotEmpty
                  ? IconButton(
                onPressed: widget.togglePasswordVisibility,
                icon: Icon(
                  widget.isPasswordVisible
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
            controller: widget.confirmPasswordController,
            obscureText: !widget.isConfirmPasswordVisible,
            style: Theme.of(context).textTheme.bodySmall,
            validator: (value) => FormValidators.validateConfirmPassword(
              context,
              value,
              widget.passwordController.text,
            ),
            decoration: InputDecoration(
              labelText: context.l10n.confirmPasswordLabel,
              hintText: context.l10n.confirmPasswordHint,
              helperText: "",
              suffixIcon: widget.confirmPasswordController.text.isNotEmpty
                  ? IconButton(
                onPressed: widget.toggleConfirmPasswordVisibility,
                icon: Icon(
                  widget.isConfirmPasswordVisible
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