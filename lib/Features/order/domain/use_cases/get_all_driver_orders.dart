import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/view_model/my_orders_state.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class GetAllDriverOrdersUseCase {
  final OrderRepoContract _orderRepoContract;

  GetAllDriverOrdersUseCase(this._orderRepoContract);

  Future<BaseResponse<MyOrdersState>> call({int limit = 100}) async {
    final response = await _orderRepoContract.getAllDriverOrders(limit: limit);

    if (response is SuccessResponse<DriverOrdersResponseEntity>) {
      final orders = response.data.orders ?? [];
      final completedCount = orders.where((o) {
        final state = o.order?.state?.toLowerCase();
        return state == 'completed' ||
            state == 'delivered' ||
            o.order?.isDelivered == true;
      }).length;
      final canceledCount = orders
          .where((o) => o.order?.state == "canceled")
          .length;

      return SuccessResponse<MyOrdersState>(
        data: MyOrdersState(
          allOrders: orders,
          completedOrdersCount: completedCount,
          canceledOrdersCount: canceledCount,
        ),
      );
    } else if (response is ErrorResponse<DriverOrdersResponseEntity>) {
      return ErrorResponse<MyOrdersState>(errorMessage: response.errorMessage);
    }

    return ErrorResponse<MyOrdersState>(errorMessage: "Unknown error");
  }
}
