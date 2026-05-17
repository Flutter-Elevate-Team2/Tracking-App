import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/response/update_order_response_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class OrderRepoContract {
  Future<BaseResponse<DriverOrdersResponseEntity>> getAllDriverOrders({
    int limit = 100,
  });
  Future<BaseResponse<UpdateOrderResponseEntity>> updateOrderState(
    String id,
    String orderState,
  );
}
