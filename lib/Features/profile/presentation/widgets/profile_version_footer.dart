import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class ProfileVersionFooter extends StatelessWidget {
  const ProfileVersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          "v 6.3.0 - (446)",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.gray),
        ),
      ),
    );
  }
}
