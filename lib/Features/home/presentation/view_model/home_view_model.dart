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
        (state.currentPage == 1 &&
            (state.ordersState?.data == null ||
                state.ordersState!.data!.isEmpty));

    try {
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

        final initialRes = await _getPendingOrdersUseCase(1);
        if (isClosed) return;

        if (initialRes is SuccessResponse<HomeOrdersEntity>) {
          final totalPages = initialRes.data.totalPages;
          List<OrderEntity> allFetchedOrders = [];

          int cursor = totalPages;

          while (cursor >= 1 && allFetchedOrders.length < 10) {
            if (cursor == 1) {
              allFetchedOrders.addAll(initialRes.data.orders.reversed);
              cursor--;
              break;
            }

            final pageRes = await _getPendingOrdersUseCase(cursor);
            if (isClosed) return;

            if (pageRes is SuccessResponse<HomeOrdersEntity>) {
              allFetchedOrders.addAll(pageRes.data.orders.reversed);
              cursor--;
            } else {
              break;
            }
          }

          emit(
            state.copyWith(
              ordersState: BaseState(isLoading: false, data: allFetchedOrders),
              currentPage: cursor,
              hasReachedMax: cursor < 1,
            ),
          );
        } else if (initialRes is ErrorResponse<HomeOrdersEntity>) {
          emit(
            state.copyWith(
              ordersState: BaseState(
                isLoading: false,
                errorMessage: initialRes.errorMessage,
              ),
            ),
          );
        }
      } else {
        emit(state.copyWith(isPaginationLoading: true));

        final pageToFetch = state.currentPage;

        if (pageToFetch < 1) {
          emit(state.copyWith(isPaginationLoading: false, hasReachedMax: true));
          return;
        }

        final response = await _getPendingOrdersUseCase(pageToFetch);
        if (isClosed) return;

        if (response is SuccessResponse<HomeOrdersEntity>) {
          final newOrders = response.data.orders.reversed.toList();
          final currentOrders = List<OrderEntity>.from(
            state.ordersState?.data ?? [],
          );

          emit(
            state.copyWith(
              ordersState: state.ordersState?.copyWith(
                data:
                    currentOrders +
                    newOrders,
              ),
              isPaginationLoading: false,
              currentPage: pageToFetch - 1,
              hasReachedMax: (pageToFetch - 1) < 1,
            ),
          );
        } else if (response is ErrorResponse<HomeOrdersEntity>) {
          emit(state.copyWith(isPaginationLoading: false));
        }
      }
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          ordersState: BaseState(isLoading: false, errorMessage: e.toString()),
          isPaginationLoading: false,
        ),
      );
    }
  }

  Future<void> _acceptOrder(AcceptOrderEvent event) async {
    emit(state.copyWith(acceptOrderState: const BaseState(isLoading: true)));

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
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          acceptOrderState: BaseState(
            isLoading: false,
            errorMessage: e.toString(),
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
