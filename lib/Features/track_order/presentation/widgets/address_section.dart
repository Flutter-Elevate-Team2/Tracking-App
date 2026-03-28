import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/constants/assets_manager.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class AddressSection extends StatelessWidget {
  final String label;
  final String name;
  final String address;
  final String imagePath;
  final VoidCallback? onPhoneTap;
  final VoidCallback? onChatTap;

  const AddressSection({
    super.key,
    required this.label,
    required this.name,
    required this.address,
    required this.imagePath,
    this.onPhoneTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.lightGray),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.lightGray,
                    child: Icon(Icons.person, color: AppColors.gray),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTheme.getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.black,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: AppTheme.getTextStyle(
                              fontSize: 12,
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSocialIcon(
                    icon: Icons.phone_outlined,
                    color: AppColors.mainColor,
                    onTap: onPhoneTap,
                  ),
                  const SizedBox(width: 8),
                  _buildSocialIcon(
                    imagePath: AssetsManager.whatsapp,
                    onTap: onChatTap,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSocialIcon({
    IconData? icon,
    String? imagePath,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        child: imagePath != null
            ? Image.asset(imagePath, width: 22, height: 22, fit: BoxFit.contain)
            : Icon(icon, size: 20, color: color),
      ),
    );
  }
}
