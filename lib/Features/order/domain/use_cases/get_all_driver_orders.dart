import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

@injectable
class GetAllDriverOrders {
  final OrderRepoContract _orderRepoContract;
  GetAllDriverOrders(this._orderRepoContract);

  Future<BaseResponse<List<DriverOrdersEntity>>> call({
    required OrderFilter filter,
  }) async {
    final response = await _orderRepoContract.getAllDriverOrders();

    if (response is SuccessResponse<DriverOrdersResponseEntity>) {
      final orders = response.data.orders ?? [];

      final filteredOrders = _applyFilter(orders, filter);

      return SuccessResponse(data: filteredOrders);
    } else if (response is ErrorResponse<DriverOrdersResponseEntity>) {
      return ErrorResponse(errorMessage: response.errorMessage);
    }

    return ErrorResponse(errorMessage: "Unknown error");
  }

  List<DriverOrdersEntity> _applyFilter(
      List<DriverOrdersEntity> orders,
      OrderFilter filter,
      ) {
    switch (filter) {
      case OrderFilter.completed:
        return orders
            .where((o) => o.order?.state == ApiConstants.completed)
            .toList();

      case OrderFilter.cancelled:
        return orders
            .where((o) => o.order?.state == ApiConstants.cancelled)
            .toList();
    }
  }
}

enum OrderFilter {
  cancelled,
  completed,
}
