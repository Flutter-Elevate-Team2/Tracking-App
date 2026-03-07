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
      case ResetAcceptOrderStateEvent():
        _resetAcceptOrderState();
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

      // 1. First fetch to get totalPages
      final initialResponse = await _getPendingOrdersUseCase(1);

      if (initialResponse is SuccessResponse<HomeOrdersEntity>) {
        final totalPages = initialResponse.data.totalPages;

        if (totalPages <= 1) {
          // Only one page or no pages, just use the reversed data from page 1
          emit(
            state.copyWith(
              ordersState: BaseState(
                isLoading: false,
                data: initialResponse.data.orders.reversed.toList(),
              ),
              currentPage: 1,
              hasReachedMax: true,
            ),
          );
        } else {
          // 2. Multiple pages, fetch the last page as the "first" visible page
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
          } else if (lastPageResponse is ErrorResponse<HomeOrdersEntity>) {
            emit(
              state.copyWith(
                ordersState: BaseState(
                  isLoading: false,
                  errorMessage: lastPageResponse.errorMessage,
                ),
              ),
            );
          }
        }
      } else if (initialResponse is ErrorResponse<HomeOrdersEntity>) {
        emit(
          state.copyWith(
            ordersState: BaseState(
              isLoading: false,
              errorMessage: initialResponse.errorMessage,
            ),
          ),
        );
      }
    } else {
      // Pagination Logic (fetching backwards)
      emit(state.copyWith(isPaginationLoading: true));

      final pageToFetch = state.currentPage - 1;
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

  void _resetAcceptOrderState() {
    emit(state.copyWith(acceptOrderState: const BaseState()));
  }
}
