import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/Features/track_order/domain/entities/track_order_status.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class OrderStatusHeader extends StatelessWidget {
  final OrderStatus status;
  final String orderId;
  final DateTime date;

  const OrderStatusHeader({
    super.key,
    required this.status,
    required this.orderId,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.l10n.status} : ${status.firebaseValue}',
            style: const TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${context.l10n.orderID} : $orderId',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEE, dd MMM yyyy, hh:mm a').format(date),
            style: TextStyle(color: AppColors.gray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
