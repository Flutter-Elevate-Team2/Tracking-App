import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_action_button.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/waiting_confirmation_button.dart';
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
    final bool isWaitingConfirmation = currentStatus == OrderStatus.delivered;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: AppColors.lightGray,
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: isWaitingConfirmation
          ? const WaitingConfirmationButton()
          : OrderActionButton(
              status: currentStatus,
              onPressed: () {
                final next = currentStatus.next;

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
}
