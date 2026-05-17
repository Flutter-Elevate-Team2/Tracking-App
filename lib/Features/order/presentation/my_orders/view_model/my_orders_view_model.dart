import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/order/domain/use_cases/get_all_driver_orders.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@lazySingleton
class MyOrdersViewModel extends Cubit<MyOrdersState> {
  final GetAllDriverOrdersUseCase getDriverOrders;
  MyOrdersViewModel(this.getDriverOrders) : super(const MyOrdersState());
  void doIntent(MyOrdersEvent event) {
    if (event is GetDriverOrdersEvent) {
      _getOrders();
    }
  }

  Future<void> _getOrders() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final BaseResponse<MyOrdersState> response = await getDriverOrders.call();

    if (response is SuccessResponse<MyOrdersState>) {
      final completedOrders = response.data.allOrders
          .where((order) => order.order?.state == 'completed')
          .toList();

      emit(
        state.copyWith(
          isLoading: false,
          allOrders: completedOrders,
          completedOrdersCount: response.data.completedOrdersCount,
          canceledOrdersCount: response.data.canceledOrdersCount,
        ),
      );
    } else if (response is ErrorResponse<MyOrdersState>) {
      emit(
        state.copyWith(isLoading: false, errorMessage: response.errorMessage),
      );
    }
  }
}
