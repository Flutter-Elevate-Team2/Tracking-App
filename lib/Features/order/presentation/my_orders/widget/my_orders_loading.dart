import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

class MyOrdersLoading extends StatelessWidget {
  const MyOrdersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.all(16),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: AppShimmer(height: 70,)),
              const SizedBox(width: 16),
              Expanded(child: AppShimmer(height: 70,),)
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2,
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
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        AppShimmer(height: 30, width: 30),
                        SizedBox(width: 16),
                        AppShimmer(height: 30, width: 160),
                        Spacer(),
                        AppShimmer(height: 30, width: 120),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                  ],
                ),
              );
            },
          )
        ],
      )),
    );
  }
}