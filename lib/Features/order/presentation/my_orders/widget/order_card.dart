import 'package:flutter/material.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/address_info_row.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_state.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class OrderCard extends StatelessWidget {
  final DriverOrdersEntity orders;

  const OrderCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final order = orders.order;
    final store = orders.store;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.white[10],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.flowerOrder,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                OrderState(order!.state ?? ''),
                Text(
                  order.orderNumber ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AddressInfoRow(
              label: context.l10n.pickupAddress,
              order: order
             ,store: store!,
            isUser: false,),
            const SizedBox(height: 16),
            AddressInfoRow(
              label: context.l10n.userAddress,
              order: order,
              store: store,
              isUser: true,
            ),
          ],
        ),
      ),
    );
  }
}
