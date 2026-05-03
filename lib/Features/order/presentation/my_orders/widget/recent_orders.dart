import 'package:flutter/material.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/orders_list.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class RecentOrders extends StatelessWidget {
  final List<DriverOrdersEntity> orders;
  const RecentOrders(this.orders, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          context.l10n.recentOrders,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Expanded(child: OrdersList(orders)),
      ],
    );
  }
}
