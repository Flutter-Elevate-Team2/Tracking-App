import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:tracking_app/Features/track_order/api/api_client/api_client.dart';
import 'package:tracking_app/Features/track_order/data/model/complete/complete.order_response.dart';
import 'package:tracking_app/Features/track_order/data/remote_data_source_contract/map_remote_data_source_contract.dart';

@Injectable(as: MapRemoteDataSourceContract)
class MapRemoteDataSourceImpl implements MapRemoteDataSourceContract {
  final MapboxApiClient _apiClient;

  MapRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<mapbox.Position>> getRoute(
    mapbox.Position start,
    mapbox.Position end,
  ) async {
    final String coordinates =
        "${start.lng},${start.lat};${end.lng},${end.lat}";
    final String token = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

    final response = await _apiClient.getDirections(
      coordinates,
      "geojson",
      "full",
      token,
    );

    final List coordinatesList =
        response['routes'][0]['geometry']['coordinates'];
    return coordinatesList.map((p) => mapbox.Position(p[0], p[1])).toList();
  }

  @override
  Future<CompleteOrderResponse> changeOrderState(
    String orderId,
    Map<String, dynamic> body,
  ) {
    return _apiClient.changeOrderState(orderId, body);
  }
}
