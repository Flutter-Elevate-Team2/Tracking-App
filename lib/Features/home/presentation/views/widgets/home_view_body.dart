import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/home_shimmer_loading.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/order_card.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeViewModel>().doIntent(GetPendingOrdersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeViewModel, HomeState>(
      listener: (context, state) {
        if (state.acceptOrderState?.isLoading == false) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }

        if (state.acceptOrderState?.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.acceptOrderState!.errorMessage!)),
          );
        }

        if (state.acceptOrderState?.isLoading == true) {
          showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: true,
            builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              content: Row(
                children: [
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      context.l10n.acceptingOrder,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.acceptOrderState?.data != null &&
            state.acceptOrderState?.isLoading == false) {
          final String orderId = state.acceptOrderState!.data!.id.toString();

          context.pushNamed(
            Routes.trackOrderName,
            pathParameters: {'orderId': orderId},
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
                      ResetAcceptOrderStateEvent(),
                    );
                    context.read<HomeViewModel>().doIntent(
                      GetPendingOrdersEvent(isRefresh: true),
                    );
                  },
                  child: isLoading
                      ? const HomeShimmerLoading()
                      : errorMessage != null
                      ? Center(child: Text(errorMessage))
                      : orders.isEmpty
                      ? const Center(child: Text('No pending orders'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              orders.length +
                              (state.isPaginationLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < orders.length) {
                              return OrderCard(order: orders[index]);
                            } else {
                              return const _PaginatingShimmer();
                            }
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

class _PaginatingShimmer extends StatelessWidget {
  const _PaginatingShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppShimmer(height: 20, width: 120),
          SizedBox(height: 16),
          AppShimmer(height: 14, width: 100),
          SizedBox(height: 16),
          AppShimmer(height: 40, radius: 100),
        ],
      ),
    );
  }
}
