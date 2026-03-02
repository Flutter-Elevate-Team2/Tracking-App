import 'package:flutter/material.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const EmailField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: TextFormField(
        key: Key('emailField'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => FormValidators.validateEmail(context, value),
        controller: controller,
        onChanged: (_) => onChanged(),
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          labelText: context.l10n.emailLabel,
          hintText: context.l10n.emailHint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
