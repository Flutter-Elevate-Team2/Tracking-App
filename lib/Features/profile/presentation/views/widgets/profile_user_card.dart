import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/string_extension.dart';
import 'package:tracking_app/gen/assets.gen.dart';

class ProfileUserCard extends StatelessWidget {
  final DriverEntity driver;
  final VoidCallback onTap;

  const ProfileUserCard({super.key, required this.driver, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGray.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.lightGray, width: 1),
              ),
              child: CachedNetworkImage(
                imageUrl: driver.photo.toImageUrl,
                imageBuilder: (context, imageProvider) =>
                    CircleAvatar(radius: 32, backgroundImage: imageProvider),
                placeholder: (context, url) => const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.lightGray,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.gray,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.lightGray,
                  child: Icon(Icons.person, color: AppColors.gray, size: 32),
                ),
              ),
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
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.phone,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Assets.images.arrowBackIos.image(
              width: 20,
              height: 20,
              color: AppColors.gray,
            ),
          ],
        ),
      ),
    );
  }
}
