import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/order/domain/entities/response/update_order_response_entity.dart';
import 'package:tracking_app/Features/order/domain/repo/order_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class UpdateOrderStateUseCase {
  final OrderRepoContract _orderRepoContract;
  UpdateOrderStateUseCase(this._orderRepoContract);
  Future<BaseResponse<UpdateOrderResponseEntity>> call(
      String id,
      String orderState,
      ) async {
    return await _orderRepoContract.updateOrderState(id, orderState);
  }
}
