import 'package:flutter/material.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class NameFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const NameFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TextFormField(
          key: const Key('firstNameField'),
          textInputAction: TextInputAction.next,
          controller: firstNameController,
          validator: (value) => FormValidators.validateRequired(
            value,
            context.l10n.firstNameRequired,
          ),
          style: theme.textTheme.bodySmall,
          decoration: InputDecoration(
            labelText: context.l10n.firstNameLabel,
            hintText: context.l10n.firstNameHint,
          ),
        ),
        const SizedBox(height: 25),
        TextFormField(
          key: const Key('lastNameField'),
          textInputAction: TextInputAction.next,
          controller: lastNameController,
          validator: (value) => FormValidators.validateRequired(
            value,
            context.l10n.secondNameRequired,
          ),
          style: theme.textTheme.bodySmall,
          decoration: InputDecoration(
            labelText: context.l10n.secondNameLabel,
            hintText: context.l10n.secondNameHint,
          ),
        ),
      ],
    );
  }
}
