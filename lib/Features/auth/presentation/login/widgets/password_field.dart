import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const PasswordField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key('passwordField'),
      textInputAction: TextInputAction.done,
      validator: (value) =>
          FormValidators.validateLoginPassword(context, value),
      obscureText: !_isVisible,
      controller: widget.controller,
      onChanged: (value) {
        widget.onChanged();
      },
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        labelText: context.l10n.passwordLabel,
        hintText: context.l10n.passwordHint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        helperText: ' ',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: Icon(
            _isVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.gray,
          ),
        ),
      ),
    );
  }
}
