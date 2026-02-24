import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class GetAllDriverOrdersUseCase {
  final OrderRepoContract _orderRepoContract;

  GetAllDriverOrdersUseCase(this._orderRepoContract);

  Future<BaseResponse<DriverOrdersResponseEntity>> call() async {
    return _orderRepoContract.getAllDriverOrders();
  }
}

