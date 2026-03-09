import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_events.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_state.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/complet_order/complete_order_view_model.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/bottom_order_button.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_addresses_section.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_items_section.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_status_header.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_stepper.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_summary_card.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackOrderBody extends StatefulWidget {
  final String orderId;

  const TrackOrderBody({super.key, required this.orderId});

  @override
  State<TrackOrderBody> createState() => _TrackOrderBodyState();
}

class _TrackOrderBodyState extends State<TrackOrderBody>
    with WidgetsBindingObserver {
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenToForegroundNotification();
    context.read<OrderStatusViewModel>().doIntent(
          context,
          FetchOrderDetailsEvent(widget.orderId),
        );
  }

  void _listenToForegroundNotification() {
    _fcmSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      if (message.data['action'] == 'customer_confirmed' &&
          message.data['orderId'] == widget.orderId) {
        context.read<CompleteOrderViewModel>().doIntent(
              CompleteOrderEvent(orderId: widget.orderId),
            );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fcmSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!mounted) return;
      SharedPreferences.getInstance().then((prefs) {
        prefs.reload().then((_) {
          if (!mounted) return;

          final showSuccess = prefs.getBool('show_success_screen') ?? false;
          if (showSuccess) {
            context.goNamed(Routes.successName);
            return;
          }

          final activeOrderId = prefs.getString(ApiConstants.currentOrderIdKey);
          if (activeOrderId == null || activeOrderId != widget.orderId) {
            context.go(Routes.homePath);
          } else {
            context.read<OrderStatusViewModel>().doIntent(
                  context,
                  FetchOrderDetailsEvent(widget.orderId),
                );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrderStatusViewModel>().state;
    final order = state.orderState?.data;

    return MultiBlocListener(
      listeners: [
        BlocListener<CompleteOrderViewModel, CompleteOrderState>(
          listenWhen: (prev, next) =>
              prev.completeOrderState != next.completeOrderState,
          listener: (context, completeState) {
            final stateData = completeState.completeOrderState;

            if (stateData.data != null) {
              context.pushReplacementNamed(Routes.successName);
            } else if (stateData.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(stateData.errorMessage!)));
            }
          },
        ),
        BlocListener<OrderStatusViewModel, TrackOrderStatusState>(
          listenWhen: (prev, next) =>
              prev.orderState?.errorMessage != next.orderState?.errorMessage ||
              prev.orderState?.data?.status != next.orderState?.data?.status,
          listener: (context, trackState) {
            // 1. If we can't find the order
            if (trackState.orderState?.errorMessage != null) {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove(ApiConstants.currentOrderIdKey);
                final driverId = prefs.getString(ApiConstants.driverIdKey) ?? '';
                if (driverId.isNotEmpty) {
                  getIt<ActiveOrderFirestoreService>().clearActiveOrder(
                    driverId,
                  );
                }
              });
              context.go(Routes.homePath);
            }

            // 2. Auto-check: If order is completed (done by customer while driver was offline)
            final orderData = trackState.orderState?.data;
            if (orderData != null && orderData.status == 'completed') {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove(ApiConstants.currentOrderIdKey);
                final driverId = prefs.getString(ApiConstants.driverIdKey) ?? '';
                if (driverId.isNotEmpty) {
                  getIt<ActiveOrderFirestoreService>().clearActiveOrder(driverId);
                }
              });
              context.pushReplacementNamed(Routes.successName);
            }
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          if (order == null) return const SizedBox.shrink();

          final currentStatus = OrderStatus.fromFirebase(order.status);

          return PopScope(
            canPop: false,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.exitDeliveredOrderWarning),
                      ),
                    );
                  },
                ),
               actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      context.read<OrderStatusViewModel>().doIntent(
                            context,
                            SyncOrderWithBackendEvent(widget.orderId),
                          );
                    },
                  )
                ],
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
                orderId: widget.orderId,
                currentStatus: currentStatus,
                userToken: order.user.deviceToken,
              ),
            ),
          );
        },
      ),
    );
  }
}