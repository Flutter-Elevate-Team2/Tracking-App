import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_card.dart';
import 'package:tracking_app/core/app_router/app_router.dart';

class OrdersList extends StatefulWidget {
  final List<DriverOrdersEntity> orders;
  const OrdersList(this.orders, {super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        final order = widget.orders[index];
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
