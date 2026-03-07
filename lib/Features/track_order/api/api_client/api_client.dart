import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/Features/track_order/data/model/complete_order_response/complete_order_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.mapbox.com/")
@injectable
abstract class MapboxApiClient {
  @factoryMethod
  factory MapboxApiClient(Dio dio) = _MapboxApiClient;

  @GET("directions/v5/mapbox/driving/{coordinates}")
  Future<dynamic> getDirections(
    @Path("coordinates") String coordinates,
    @Query("geometries") String geometries,
    @Query("overview") String overview,
    @Query("access_token") String accessToken,
  );
  @PUT('https://flower.elevateegy.com/api/v1/orders/state/{orderId}')
  Future<CompleteOrderResponse> changeOrderState(
    @Path('orderId') String orderId,
    @Body() Map<String, dynamic> body,
  );
}
