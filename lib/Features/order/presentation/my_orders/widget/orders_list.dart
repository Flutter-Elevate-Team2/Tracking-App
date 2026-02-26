import 'package:flutter/material.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_card.dart';

class OrdersList extends StatelessWidget {
  final List<DriverOrdersEntity> orders;
  const OrdersList(this.orders, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(orders: order);
      },
    );
  }
}
