import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/order/api/api_client/order_api.dart';
import 'package:tracking_app/Features/order/data/data_source/order_remote_data_source/order_remote_data_source_contract.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';

@LazySingleton(as: OrderRemoteDataSourceContract)
class OrderRemoteDataSourceImple implements OrderRemoteDataSourceContract {
  final OrderApi _orderApi;
  OrderRemoteDataSourceImple(this._orderApi);

  @override
  Future<DriverOrdersResponse> getAllDriverOrders() {
    return _orderApi.getAllDriverOrders();
  }

  @override
  Future<UpdateOrderResponse> updateOrderState(
    String id,
    String orderState,
  ) {
    return _orderApi.updateOrderState(id, orderState);
  }

}
