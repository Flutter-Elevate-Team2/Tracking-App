import 'package:flutter/material.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key("email_field_input"),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall,
      validator: (value) =>
          FormValidators.validateEmail(context, value),
      decoration: InputDecoration(
        labelText: context.l10n.emailLabel,
        hintText: context.l10n.emailHint,
        helperText: "",
      ),
    );
  }
}
