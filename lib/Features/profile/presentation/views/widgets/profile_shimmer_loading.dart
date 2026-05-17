import 'package:flutter/material.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

class ProfileShimmerLoading extends StatelessWidget {
  const ProfileShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            // Replicating ProfileUserCard
            AppShimmer(height: 120, radius: 16),
            SizedBox(height: 16),
            // Replicating ProfileVehicleCard
            AppShimmer(height: 100, radius: 16),
            SizedBox(height: 24),
            // Replicating ProfileSettingsTile (Language)
            AppShimmer(height: 60, radius: 12),
            SizedBox(height: 12),
            // Replicating ProfileSettingsTile (Logout)
            AppShimmer(height: 60, radius: 12),
          ],
        ),
      ),
    );
  }
}
