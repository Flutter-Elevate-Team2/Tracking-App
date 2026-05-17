import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

class ProfileVersionFooter extends StatelessWidget {
  const ProfileVersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          l10n?.appVersion ?? "v 6.3.0 - (446)",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.gray, fontSize: 14),
        ),
      ),
    );
  }
}
