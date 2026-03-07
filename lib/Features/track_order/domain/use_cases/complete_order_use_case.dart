import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/repo/track_order_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class CompleteOrderUseCase {
  final TrackOrderRepoContract _trackOrderRepoContract;
  CompleteOrderUseCase(this._trackOrderRepoContract);
  
  Future<BaseResponse<CompleteOrderEntity>> call(
    String orderId,
  ) {
    return _trackOrderRepoContract.changeOrderState(orderId,);
  }
  
}