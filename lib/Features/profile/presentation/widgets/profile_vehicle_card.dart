import 'package:flutter/material.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

class ProfileVehicleCard extends StatelessWidget {
  final DriverEntity driver;
  final VoidCallback onTap;

  const ProfileVehicleCard({
    super.key,
    required this.driver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.vehicleInfo ?? 'Vehicle info',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    driver.vehicleType,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.gray),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    driver.vehicleNumber,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
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
