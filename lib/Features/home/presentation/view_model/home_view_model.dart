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

  Future<void> doIntent(HomeEvent event) async {
    switch (event) {
      case GetPendingOrdersEvent():
        await _getPendingOrders(isRefresh: event.isRefresh);
        break;
      case AcceptOrderEvent():
        await _acceptOrder(event);
        break;
      case RejectOrderEvent():
        _rejectOrder(event);
        break;
    }
  }

  Future<void> _getPendingOrders({bool isRefresh = false}) async {
    emit(state.copyWith(acceptOrderState: const BaseState()));

    if ((state.hasReachedMax && !isRefresh) || state.isPaginationLoading) {
      return;
    }

    final isFirstLoad =
        isRefresh ||
        state.ordersState?.data == null ||
        state.ordersState!.data!.isEmpty;

    if (isFirstLoad) {
      emit(
        state.copyWith(
          ordersState: BaseState(
            isLoading: true,
            data: isRefresh ? state.ordersState?.data : null,
          ),
          hasReachedMax: false,
        ),
      );
    } else {
      emit(state.copyWith(isPaginationLoading: true));
    }

    try {
      final response = await _getPendingOrdersUseCase(
        currentPage: state.currentPage,
        isRefresh: isRefresh,
      );
      if (isClosed) return;

      if (response is SuccessResponse<HomeOrdersEntity>) {
        final newOrders = List<OrderEntity>.from(response.data.orders);

        // Deduplicate against existing orders
        if (!isFirstLoad) {
          final existingOrders = state.ordersState?.data ?? [];
          newOrders.removeWhere(
            (newOrder) => existingOrders.any((old) => old.id == newOrder.id),
          );
        }

        final allOrders = isFirstLoad
            ? newOrders
            : <OrderEntity>[...state.ordersState?.data ?? [], ...newOrders];

        emit(
          state.copyWith(
            ordersState: BaseState(isLoading: false, data: allOrders),
            currentPage: response.data.currentPage,
            hasReachedMax: response.data.currentPage <= 1,
            isPaginationLoading: false,
          ),
        );
      } else if (response is ErrorResponse<HomeOrdersEntity>) {
        if (isFirstLoad) {
          emit(
            state.copyWith(
              ordersState: BaseState(
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
              isPaginationLoading: false,
            ),
          );
        } else {
          emit(state.copyWith(isPaginationLoading: false));
        }
      }
    } catch (e) {
      if (isClosed) return;
      if (isFirstLoad) {
        emit(
          state.copyWith(
            ordersState: BaseState(
              isLoading: false,
              errorMessage: e.toString(),
            ),
            isPaginationLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isPaginationLoading: false));
      }
    }
  }

  Future<void> _acceptOrder(AcceptOrderEvent event) async {
    emit(
      state.copyWith(
        acceptOrderState: const BaseState(isLoading: true),
        acceptingOrderId: event.order.id,
      ),
    );

    try {
      final response = await _acceptOrderUseCase(event.order);
      if (isClosed) return;

      if (response is SuccessResponse<OrderEntity>) {
        final currentOrders = List<OrderEntity>.from(
          state.ordersState?.data ?? [],
        );
        currentOrders.removeWhere((o) => o.id == event.order.id);

        emit(
          state.copyWith(
            acceptOrderState: BaseState(isLoading: false, data: response.data),
            ordersState: state.ordersState?.copyWith(data: currentOrders),
            clearAcceptingOrderId: true,
          ),
        );
      } else if (response is ErrorResponse<OrderEntity>) {
        emit(
          state.copyWith(
            acceptOrderState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
            clearAcceptingOrderId: true,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          acceptOrderState: BaseState(
            isLoading: false,
            errorMessage: e.toString(),
          ),
          clearAcceptingOrderId: true,
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
