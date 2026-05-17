import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/custom_map_back_button.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/map_bottom_sheet.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/map/order_map_body.dart';
import 'package:tracking_app/core/di/di.dart';

class OrderMapScreen extends StatelessWidget {
  final OrderTrackingEntity order;
  final bool initialShowPickup;
  const OrderMapScreen({
    super.key,
    required this.order,
    required this.initialShowPickup,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrderStatusViewModel>()
        ..changeTarget(initialShowPickup)
        ..doIntent(context, FetchOrderDetailsEvent(order.id)),
      child: const Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              OrderMapBody(),
              Positioned(top: 30, left: 20, child: CustomMapBackButton()),
              MapBottomSheet(),
            ],
          ),
        ),
      ),
    );
  }
}
