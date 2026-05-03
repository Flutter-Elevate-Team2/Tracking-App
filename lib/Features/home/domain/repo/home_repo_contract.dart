import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class HomeRepoContract {
  Future<BaseResponse<HomeOrdersEntity>> getPendingOrders(int page);
  Future<BaseResponse<OrderEntity>> startOrder(String id);
}
