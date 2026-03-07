import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class TrackOrderRepoContract {
  Future<BaseResponse<CompleteOrderEntity>> changeOrderState(String orderId);
}
