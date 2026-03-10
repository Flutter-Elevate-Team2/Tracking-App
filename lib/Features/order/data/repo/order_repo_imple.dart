import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/order/data/data_source/order_remote_data_source/order_remote_data_source_contract.dart';
import 'package:tracking_app/Features/order/data/mappers/response/driver_orders_response_mapper.dart';
import 'package:tracking_app/Features/order/data/mappers/response/update_order_state_mapper.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/response/update_order_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

@LazySingleton(as: OrderRepoContract)
class OrderRepoImple with ApiExecutionMixin implements OrderRepoContract {
  final OrderRemoteDataSourceContract _orderRemoteDataSourceContract;
  OrderRepoImple(this._orderRemoteDataSourceContract);

  @override
  Future<BaseResponse<DriverOrdersResponseEntity>> getAllDriverOrders({
    int limit = 100,
  }) {
    return execute<DriverOrdersResponse, DriverOrdersResponseEntity>(
      action: () =>
          _orderRemoteDataSourceContract.getAllDriverOrders(limit: limit),
      mapper: (response) => response.toEntity(),
    );
  }

  @override
  Future<BaseResponse<UpdateOrderResponseEntity>> updateOrderState(
    String id,
    String orderState,
  ) {
    return execute<UpdateOrderResponse, UpdateOrderResponseEntity>(
      action: () =>
          _orderRemoteDataSourceContract.updateOrderState(id, orderState),
      mapper: (response) => response.toEntity(),
    );
  }
}
