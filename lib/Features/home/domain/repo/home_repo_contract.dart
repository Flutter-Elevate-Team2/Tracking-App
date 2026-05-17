import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class HomeRepoContract {
  Future<BaseResponse<HomeOrdersEntity>> getPendingOrders({
    required int currentPage,
    required bool isRefresh,
  });
  Future<BaseResponse<OrderEntity>> startOrder(String id);
}
