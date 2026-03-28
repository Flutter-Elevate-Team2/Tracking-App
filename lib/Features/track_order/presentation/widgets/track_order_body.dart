import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/bottom_order_button.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_addresses_section.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_items_section.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_status_header.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_stepper.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_summary_card.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class TrackOrderBody extends StatelessWidget {
  final String orderId;

  const TrackOrderBody({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrderStatusViewModel>().state;
    final order = state.orderState?.data;

    if (order == null) return const SizedBox.shrink();

    final currentStatus = OrderStatus.fromFirebase(order.status);
    final bool isDelivered = currentStatus == OrderStatus.delivered;

    return PopScope(
      canPop: isDelivered,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.exitDeliveredOrderWarning)),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.orderDetails),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (isDelivered) {
                context.go(Routes.homePath);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.exitDeliveredOrderWarning),
                  ),
                );
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              OrderStepper(
                currentStep: OrderStatus.values.indexOf(currentStatus),
                isLoading: state.updateStatusState?.isLoading ?? false,
              ),
              const SizedBox(height: 20),
              OrderStatusHeader(
                status: currentStatus,
                orderId: order.orderNumber,
                date: order.updatedAt,
              ),
              const SizedBox(height: 20),
              OrderAddressesSection(order: order),
              OrderItemsSection(order: order),
              OrderSummaryCard(
                total: order.totalPrice.toString(),
                paymentMethod: order.paymentType,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomSheet: BuildBottomButton(
          orderId: orderId,
          currentStatus: currentStatus,
          userToken: order.user.deviceToken,
        ),
      ),
    );
  }
}
