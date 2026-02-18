import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/use_cases/accept_order_use_case.dart';
import 'package:tracking_app/Features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/Features/home/presentation/view_model/home_state.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final AcceptOrderUseCase _acceptOrderUseCase;

  HomeViewModel(this._getPendingOrdersUseCase, this._acceptOrderUseCase)
    : super(const HomeState());

  void doIntent(HomeEvent event) {
    switch (event) {
      case GetPendingOrdersEvent():
        _getPendingOrders();
        break;
      case AcceptOrderEvent():
        _acceptOrder(event);
        break;
      case RejectOrderEvent():
        _rejectOrder(event);
        break;
    }
  }

  Future<void> _getPendingOrders() async {
    emit(state.copyWith(ordersState: const BaseState(isLoading: true)));

    final response = await _getPendingOrdersUseCase();

    if (response is SuccessResponse<List<OrderEntity>>) {
      emit(
        state.copyWith(
          ordersState: BaseState(isLoading: false, data: response.data),
        ),
      );
    } else if (response is ErrorResponse<List<OrderEntity>>) {
      emit(
        state.copyWith(
          ordersState: BaseState(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ),
      );
    }
  }

  Future<void> _acceptOrder(AcceptOrderEvent event) async {
    emit(state.copyWith(acceptOrderState: const BaseState(isLoading: true)));

    final response = await _acceptOrderUseCase(event.order);

    if (response is SuccessResponse<OrderEntity>) {
      // Remove accepted order from the pending list
      final currentOrders = List<OrderEntity>.from(
        state.ordersState?.data ?? [],
      );
      currentOrders.removeWhere((o) => o.id == event.order.id);

      emit(
        state.copyWith(
          acceptOrderState: BaseState(isLoading: false, data: response.data),
          ordersState: state.ordersState?.copyWith(data: currentOrders),
        ),
      );
    } else if (response is ErrorResponse<OrderEntity>) {
      emit(
        state.copyWith(
          acceptOrderState: BaseState(
            isLoading: false,
            errorMessage: response.errorMessage,
          ),
        ),
      );
    }
  }

  void _rejectOrder(RejectOrderEvent event) {
    final currentOrders = List<OrderEntity>.from(state.ordersState?.data ?? []);
    currentOrders.removeWhere((o) => o.id == event.orderId);

    emit(
      state.copyWith(
        ordersState: state.ordersState?.copyWith(data: currentOrders),
      ),
    );
  }
}
