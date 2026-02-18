import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightGray),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppShimmer(height: 20, width: 120),
              const SizedBox(height: 24),
              const AppShimmer(height: 14, width: 100),
              const SizedBox(height: 8),
              Row(
                children: [
                  const AppShimmer.circle(size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppShimmer(height: 14, width: 80),
                        SizedBox(height: 8),
                        AppShimmer(height: 12, width: 150),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const AppShimmer(height: 14, width: 100),
              const SizedBox(height: 8),
              Row(
                children: [
                  const AppShimmer.circle(size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppShimmer(height: 14, width: 80),
                        SizedBox(height: 8),
                        AppShimmer(height: 12, width: 150),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const AppShimmer(height: 20, width: 80),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: const [
                        Expanded(child: AppShimmer(height: 40, radius: 100)),
                        SizedBox(width: 8),
                        Expanded(child: AppShimmer(height: 40, radius: 100)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
