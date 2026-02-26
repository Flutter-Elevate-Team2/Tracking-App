import 'package:flutter/material.dart';
import 'package:tracking_app/Features/track_order/domain/entities/track_order_status.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class OrderActionButton extends StatelessWidget {
  final OrderStatus status;
  final VoidCallback onPressed;

  const OrderActionButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDelivered = status == OrderStatus.delivered;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: isDelivered ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDelivered
              ? AppColors.white[70]
              : AppColors.mainColor,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          _getActionMessage(status, context),
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getActionMessage(OrderStatus currentStatus, BuildContext context) {
    switch (currentStatus) {
      case OrderStatus.accepted:
        return context.l10n.arrivedAtPickupPointButton;
      case OrderStatus.arrivedPickup:
        return context.l10n.startDeliverButton;
      case OrderStatus.startDeliver:
        return context.l10n.arrivedToUserButton;
      case OrderStatus.arrivedUser:
        return context.l10n.deliveredToUser;
      case OrderStatus.delivered:
        return context.l10n.deliveredToUser;
    }
  }
}
