// ignore_for_file: deprecated_member_use

import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class GenderRadioRow extends StatelessWidget {
  final Gender? selectedGender;
  final void Function(Gender?)? onChanged;

  const GenderRadioRow({super.key, this.selectedGender, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          (context).l10n.genderLabel,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColors.gray),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            Radio<Gender>(
              value: Gender.female,
              groupValue: selectedGender,
              onChanged: onChanged,
              activeColor: AppColors.mainColor,
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.mainColor;
                }
                return AppColors.gray;
              }),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              (context).l10n.genderFemale,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Radio<Gender>(
              value: Gender.male,
              groupValue: selectedGender,
              onChanged: onChanged,
              activeColor: AppColors.mainColor,
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.mainColor;
                }
                return AppColors.gray;
              }),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              (context).l10n.genderMale,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

enum Gender { female, male }
