import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
 import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_state.dart';
 import 'package:tracking_app/Features/track_order/presentation/widgets/order_item_tile.dart';
   import 'package:tracking_app/Features/track_order/presentation/widgets/order_summary_card.dart';
 import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/address_info_row.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

class OrderDetailsDisplayBody extends StatelessWidget {
  final DriverOrdersEntity order;

  const OrderDetailsDisplayBody({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.orderDetails),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                OrderState(order.order!.state ?? ''),
                Text(
                  order.order!.orderNumber ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),


            const SizedBox(height: 20),

            AddressInfoRow(
              label: context.l10n.pickupAddress,
              order: order.order!,
              store: order.store!,
              isUser: false,),
            const SizedBox(height: 16),
            AddressInfoRow(
              label: context.l10n.userAddress,
              order: order.order!,
              store: order.store!,
              isUser: true,
            ),

            const SizedBox(height: 20),


            /// Items
            Column(
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
                ...(order.order!.orderItems ?? []).map(
                      (item) => OrderItemTile(
                    title: item.product!.title ?? '',
                    price: item.price.toString(),
                    quantity: item.quantity ?? 0,
                        image: (item.product!.imgCover != null && item.product!.imgCover!.isNotEmpty)
                            ? item.product!.imgCover!
                            : 'https://flower.elevateegy.com/placeholder.png',                  ),
                ),
              ],
            ),
            /// Summary
            OrderSummaryCard(
              total: order.order!.totalPrice.toString(),
              paymentMethod: order.order!.paymentType ?? context.l10n.cashOnDelivery,
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

     );
  }
}