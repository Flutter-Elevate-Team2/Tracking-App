import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';

abstract class OrderRemoteDataSourceContract {
   Future<DriverOrdersResponse>getAllDriverOrders();
  Future<UpdateOrderResponse>updateOrderState(String id,String orderState);
 }