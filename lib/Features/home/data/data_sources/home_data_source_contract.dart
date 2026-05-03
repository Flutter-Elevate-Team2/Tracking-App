import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/data/models/start_order_response_dto.dart';

abstract class HomeDataSourceContract {
  Future<OrdersResponseDto> getPendingOrders(int page);
  Future<StartOrderResponseDto> startOrder(String id);
}
