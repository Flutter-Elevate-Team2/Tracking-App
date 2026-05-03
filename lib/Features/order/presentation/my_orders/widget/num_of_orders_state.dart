import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class NumOfOrdersState extends StatelessWidget {
  final int completedOrders;
  final int canceledOrders;

  const NumOfOrdersState({
    super.key,
    required this.completedOrders,
    required this.canceledOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Canceled Orders
        buildState(canceledOrders.toString() , context.l10n.cancelled , context),
        const SizedBox(width: 8),
        // Completed Orders
        buildState(completedOrders.toString() , context.l10n.completed , context),

      ],
    );
  }

  Expanded buildState(String number, String state , BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mainColor.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Row(
              children:  [
                state == context.l10n.completed ? const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green,
                ) : const
                Icon(
                  Icons.cancel_outlined,
                  color: AppColors.red,
                ),
                SizedBox(width: 4),
                Text(
                  state,
                  style: Theme.of(context).textTheme.headlineMedium,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
