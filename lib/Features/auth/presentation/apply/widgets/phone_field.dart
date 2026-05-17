import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? countryCode;

  const PhoneField({
    super.key,
    required this.controller,
    this.countryCode = "20",
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.phone,
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall,
      validator: (value) => FormValidators.validatePhone(context, value),
      decoration: InputDecoration(
        prefixText: "+$countryCode ",
        prefixStyle: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.mainColor),
        labelText: context.l10n.phoneLabel,
        hintText: context.l10n.phoneHint,
      ),
    );
  }
}
