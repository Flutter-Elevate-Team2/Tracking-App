import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/complete_order_response.dart';

abstract class MapRemoteDataSourceContract {
  Future<List<mapbox.Position>> getRoute(
    mapbox.Position start,
    mapbox.Position end,
  );
  Future<CompleteOrderResponse> changeOrderState(
    String orderId,
    Map<String, dynamic> body,
  );
}
