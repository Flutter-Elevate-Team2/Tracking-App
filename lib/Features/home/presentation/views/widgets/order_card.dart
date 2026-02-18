import 'package:flutter/material.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/address_info_row.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.white[10],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.flowerOrder,
              style: AppTheme.getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            AddressInfoRow(
              label: context.l10n.pickupAddress,
              name: context.l10n.floweryStore,
              address: context.l10n.sampleAddress,
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.mainColor,
                child: Icon(Icons.store, color: AppColors.white),
              ),
            ),
            const SizedBox(height: 16),
            AddressInfoRow(
              label: context.l10n.userAddress,
              name: context.l10n.sampleUserName,
              address: context.l10n.sampleAddress,
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/150?u=nour',
                ), // Placeholder
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '${context.l10n.egp} 3000',
                  style: AppTheme.getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.mainColor,
                            side: BorderSide(color: AppColors.mainColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            context.l10n.reject,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            context.l10n.accept,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
