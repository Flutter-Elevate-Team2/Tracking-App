import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.black, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: titleColor ?? AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
