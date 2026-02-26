import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/track_order/domain/entities/track_order_status.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_action_button.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';

class BuildBottomButton extends StatelessWidget {
  final String orderId;
  final OrderStatus currentStatus;
  final String userToken;

  const BuildBottomButton({
    super.key,
    required this.orderId,
    required this.currentStatus,
    required this.userToken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: OrderActionButton(
        status: currentStatus,
        onPressed: () {
          final next = _getNextStatus(currentStatus);
          if (next != null) {
            context.read<OrderStatusViewModel>().doIntent(
              context,
              UpdateOrderStatusEvent(
                title: context.l10n.orderUpdated,
                orderId: orderId,
                status: next,
                userToken: userToken,
              ),
            );
          }
        },
      ),
    );
  }

  OrderStatus? _getNextStatus(OrderStatus status) {
    final index = OrderStatus.values.indexOf(status);
    if (index >= 0 && index < OrderStatus.values.length - 1) {
      return OrderStatus.values[index + 1];
    }
    return null;
  }
}
