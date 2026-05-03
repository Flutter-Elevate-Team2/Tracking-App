import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

class TrackOrderShimmer extends StatelessWidget {
  const TrackOrderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.orderDetails)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (_) => const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: AppShimmer(height: 6, radius: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Status Card
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AppShimmer(width: 120, height: 14),
                  SizedBox(height: 8),
                  AppShimmer(width: 140, height: 14),
                  SizedBox(height: 8),
                  AppShimmer(width: 180, height: 12),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Pickup Title
            _title(),
            const SizedBox(height: 12),

            /// Pickup Address Card
            _addressCard(),

            const SizedBox(height: 20),

            /// User Title
            _title(),
            const SizedBox(height: 12),

            /// User Address Card
            _addressCard(),

            const SizedBox(height: 20),

            /// Order Details Title
            _title(),
            const SizedBox(height: 12),

            /// Items
            _orderItem(),
            const SizedBox(height: 12),
            _orderItem(),

            const SizedBox(height: 20),

            /// Summary
            _summaryRow(),
            const SizedBox(height: 12),
            _summaryRow(),

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// Bottom Button
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: AppColors.white,
        child: const AppShimmer(height: 50, radius: 25),
      ),
    );
  }

  Widget _title() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: AppShimmer(width: 130, height: 16),
    );
  }

  Widget _addressCard() {
    return _card(
      child: Row(
        children: const [
          AppShimmer.circle(size: 50),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: 140, height: 14),
                SizedBox(height: 8),
                AppShimmer(width: 200, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderItem() {
    return _card(
      child: Row(
        children: const [
          AppShimmer.circle(size: 45),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: 180, height: 14),
                SizedBox(height: 8),
                AppShimmer(width: 60, height: 12),
              ],
            ),
          ),
          AppShimmer(width: 30, height: 14),
        ],
      ),
    );
  }

  Widget _summaryRow() {
    return _card(
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppShimmer(width: 80, height: 14),
          AppShimmer(width: 70, height: 14),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
