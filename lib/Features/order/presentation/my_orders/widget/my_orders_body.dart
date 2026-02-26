import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/num_of_orders_state.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/recent_orders.dart';

class MyOrdersBody extends StatefulWidget {
  const MyOrdersBody({super.key});

  @override
  State<MyOrdersBody> createState() => _MyOrdersBodyState();
}

class _MyOrdersBodyState extends State<MyOrdersBody> {
  @override
  void initState() {
    super.initState();
    context.read<MyOrdersViewModel>().doIntent(GetDriverOrdersEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyOrdersViewModel, MyOrdersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              NumOfOrdersState(
                completedOrders: state.completedOrdersCount,
                canceledOrders: state.canceledOrdersCount,
              ),
              const SizedBox(height: 16),
              Expanded(child: RecentOrders(state.allOrders)),
            ],
          ),
        );
      },
    );
  }
}
