import 'package:flutter/material.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

class ProfileUserCard extends StatelessWidget {
  final DriverEntity driver;
  final VoidCallback onTap;

  const ProfileUserCard({super.key, required this.driver, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Assuming driver.photo is a URL.
    // If it's a local asset, we'd use AssetImage.
    // Given "DriverEntity", it's likely remote data.
    final hasImage = driver.photo.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: hasImage ? NetworkImage(driver.photo) : null,
              backgroundColor: AppColors.lightGray,
              child: !hasImage
                  ? const Icon(Icons.person, color: AppColors.gray, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${driver.firstName} ${driver.lastName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.email,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.gray),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.phone,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.gray),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}
