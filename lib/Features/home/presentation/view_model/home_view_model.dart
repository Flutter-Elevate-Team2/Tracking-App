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
        _getPendingOrders(isRefresh: event.isRefresh);
        break;
      case AcceptOrderEvent():
        _acceptOrder(event);
        break;
      case RejectOrderEvent():
        _rejectOrder(event);
        break;
    }
  }

  Future<void> _getPendingOrders({bool isRefresh = false}) async {
    if ((state.hasReachedMax && !isRefresh) || state.isPaginationLoading) {
      return;
    }

    final isFirstPage =
        isRefresh ||
        (state.currentPage == 1 &&
            (state.ordersState?.data == null ||
                state.ordersState!.data!.isEmpty));

    if (isFirstPage) {
      emit(
        state.copyWith(
          ordersState: const BaseState(isLoading: true),
          currentPage: 1,
          hasReachedMax: false,
        ),
      );

      final response = await _getPendingOrdersUseCase(1);

      if (response is SuccessResponse<HomeOrdersEntity>) {
        final totalPages = response.data.totalPages;
        if (totalPages > 1) {
          final lastPageResponse = await _getPendingOrdersUseCase(totalPages);
          if (lastPageResponse is SuccessResponse<HomeOrdersEntity>) {
            emit(
              state.copyWith(
                ordersState: BaseState(
                  isLoading: false,
                  data: lastPageResponse.data.orders.reversed.toList(),
                ),
                currentPage: totalPages,
                hasReachedMax: totalPages <= 1,
              ),
            );
          } else {
            emit(
              state.copyWith(
                ordersState: const BaseState(
                  isLoading: false,
                  errorMessage: "Failed to fetch orders",
                ),
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              ordersState: BaseState(
                isLoading: false,
                data: response.data.orders.reversed.toList(),
              ),
              currentPage: 1,
              hasReachedMax: true,
            ),
          );
        }
      } else if (response is ErrorResponse<HomeOrdersEntity>) {
        emit(
          state.copyWith(
            ordersState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
      }
    } else {
      emit(state.copyWith(isPaginationLoading: true));

      final pageToFetch = state.currentPage - 1;
      if (pageToFetch < 1) {
        emit(state.copyWith(isPaginationLoading: false, hasReachedMax: true));
        return;
      }
      final response = await _getPendingOrdersUseCase(pageToFetch);

      if (response is SuccessResponse<HomeOrdersEntity>) {
        final newOrders = response.data.orders.reversed.toList();
        final currentOrders = List<OrderEntity>.from(
          state.ordersState?.data ?? [],
        );

        emit(
          state.copyWith(
            ordersState: state.ordersState?.copyWith(
              data: currentOrders + newOrders,
            ),
            isPaginationLoading: false,
            currentPage: pageToFetch,
            hasReachedMax: pageToFetch <= 1,
          ),
        );
      } else if (response is ErrorResponse<HomeOrdersEntity>) {
        emit(state.copyWith(isPaginationLoading: false));
      }
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
