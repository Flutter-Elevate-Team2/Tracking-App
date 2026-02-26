import 'package:flutter/material.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_item_tile.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class OrderItemsSection extends StatelessWidget {
  final OrderTrackingEntity order;

  const OrderItemsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            context.l10n.orderDetails,
            style: AppTheme.getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...order.items.map(
          (item) => OrderItemTile(
            title: item.name,
            price: item.price,
            quantity: item.quantity,
          ),
        ),
      ],
    );
  }
}
