import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/track_order/domain/entities/track_order_status.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/get_order_details_use_case.dart';
import 'package:tracking_app/Features/track_order/domain/use_cases/track_order_use_case.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_event.dart';
import 'package:tracking_app/Features/track_order/presentation/view_model/track_order_state.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

@injectable
class OrderStatusViewModel extends Cubit<TrackOrderStatusState> {
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;

  OrderStatusViewModel(
    this._updateOrderStatusUseCase,
    this._getOrderDetailsUseCase,
  ) : super(const TrackOrderStatusState());

  void doIntent(BuildContext context, TrackOrderStatusEvent event) {
    switch (event) {
      case FetchOrderDetailsEvent():
        _fetchOrderDetails(event.orderId);
        break;
      case UpdateOrderStatusEvent():
        _updateStatus(
          context,
          orderId: event.orderId,
          status: event.status,
          userToken: event.userToken,
          title: event.title,
        );
        break;
    }
  }

  Future<void> _fetchOrderDetails(String orderId) async {
    if (state.orderState?.data == null) {
      emit(state.copyWith(orderState: const BaseState(isLoading: true)));
    } else {
      emit(
        state.copyWith(orderState: state.orderState?.copyWith(isLoading: true)),
      );
    }
    try {
      final response = await _getOrderDetailsUseCase(orderId);

      if (response != null) {
        emit(
          state.copyWith(
            orderState: BaseState(isLoading: false, data: response),
          ),
        );
      } else {
        emit(
          state.copyWith(
            orderState: const BaseState(
              isLoading: false,
              errorMessage: "Order Not Found",
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          orderState: BaseState(isLoading: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  Future<void> _updateStatus(
    BuildContext context, {
    required String orderId,
    required OrderStatus status,
    required String userToken,
    required String title,
  }) async {
    emit(state.copyWith(updateStatusState: const BaseState(isLoading: true)));

    try {
      await _updateOrderStatusUseCase(
        title: title,
        orderId: orderId,
        status: status,
        userToken: userToken,
        body: _getNotificationBody(context, status),
      );

      if (status == OrderStatus.delivered) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(ApiConstants.currentOrderIdKey);
      }

      emit(
        state.copyWith(updateStatusState: const BaseState(isLoading: false)),
      );
      _fetchOrderDetails(orderId);
    } catch (e) {
      emit(
        state.copyWith(
          updateStatusState: BaseState(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  String _getNotificationBody(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return context.l10n.orderAcceptedBody;
      case OrderStatus.arrivedPickup:
        return context.l10n.notificationArrivedPickup;
      case OrderStatus.startDeliver:
        return context.l10n.notificationStartDeliver;
      case OrderStatus.arrivedUser:
        return context.l10n.notificationArrivedUser;
      case OrderStatus.delivered:
        return context.l10n.notificationDelivered;
    }
  }
}
