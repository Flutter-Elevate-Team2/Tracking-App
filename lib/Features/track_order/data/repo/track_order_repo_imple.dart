import 'package:tracking_app/Features/track_order/data/mapper/complet_order_mapper.dart';
import 'package:tracking_app/Features/track_order/data/model/complete/complete.order_response.dart';
import 'package:tracking_app/Features/track_order/data/remote_data_source_contract/map_remote_data_source_contract.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/Features/track_order/domain/repo/track_order_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

class TrackOrderRepoImple with ApiExecutionMixin implements TrackOrderRepoContract {
  final MapRemoteDataSourceContract _mapRemoteDataSourceContract;
  TrackOrderRepoImple(this._mapRemoteDataSourceContract);
  @override
  Future<BaseResponse<CompleteOrderEntity>> changeOrderState(
    String orderId,
  ) {
    final requestBody = {
      "state": "completed"
    };
    return execute<CompleteOrderResponse,CompleteOrderEntity>(
      action: () => _mapRemoteDataSourceContract.changeOrderState(orderId, requestBody),
      mapper: (response) => response.toEntity(),
    );
  }
}