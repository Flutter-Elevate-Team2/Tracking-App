import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_shimmer_loading.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/order_card.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeViewModel, HomeState>(
      listener: (context, state) {
        if (state.acceptOrderState?.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.acceptOrderState!.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.ordersState?.isLoading ?? false;
        final orders = state.ordersState?.data ?? [];
        final errorMessage = state.ordersState?.errorMessage;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeViewModel>().doIntent(
                      GetPendingOrdersEvent(),
                    );
                  },
                  child: isLoading
                      ? const HomeShimmerLoading()
                      : errorMessage != null
                      ? Center(child: Text(errorMessage))
                      : orders.isEmpty
                      ? const Center(child: Text('No pending orders'))
                      : ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return OrderCard(order: orders[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
