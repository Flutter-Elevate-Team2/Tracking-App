import 'package:flutter/material.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 6),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.phone,
        controller: controller,
        style: Theme.of(context).textTheme.bodySmall,
        validator: (value) => FormValidators.validatePhone(context, value),
        decoration: InputDecoration(
          labelText: context.l10n.phoneLabel,
          hintText: context.l10n.phoneHint,
          helperText: "",
        ),
      ),
    );
  }
}
