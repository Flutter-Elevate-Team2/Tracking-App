import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_body.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_shimmer.dart';
import 'package:tracking_app/core/di/di.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  const TrackOrderScreen({required this.orderId, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<OrderStatusViewModel>()
                ..doIntent(context, FetchOrderDetailsEvent(orderId)),
        ),
        BlocProvider(create: (_) => getIt<CompleteOrderViewModel>()),
      ],
      child: Scaffold(
        body: BlocBuilder<OrderStatusViewModel, TrackOrderStatusState>(
          builder: (context, state) {
            final orderState = state.orderState;

            if (orderState?.isLoading == true && orderState?.data == null) {
              return const TrackOrderShimmer();
            }

            if (orderState?.errorMessage != null && orderState?.data == null) {
              return Center(child: Text(orderState!.errorMessage!));
            }

            if (orderState?.data != null) {
              return TrackOrderBody(orderId: orderId);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
