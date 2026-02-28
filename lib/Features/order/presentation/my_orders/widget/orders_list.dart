import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_card.dart';
import 'package:tracking_app/core/app_router/app_router.dart';

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
        return InkWell(
          onTap: () {
            context.pushNamed(
              Routes.orderDetailsName,
              extra: order,
            );
          },
          child: OrderCard(orders: order),
        );
      },
    );
  }
}
