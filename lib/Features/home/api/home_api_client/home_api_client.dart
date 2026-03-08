import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/data/models/start_order_response_dto.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

part 'home_api_client.g.dart';

@lazySingleton
@injectable
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @Headers({
    "Cache-Control": "no-cache, no-store, must-revalidate",
    "Pragma": "no-cache",
    "Expires": "0",
  })
  @GET(ApiConstants.pendingOrders)
  Future<OrdersResponseDto> getPendingOrders(@Query("page") int page);

  @PUT("${ApiConstants.startOrder}{id}")
  Future<StartOrderResponseDto> startOrder(@Path("id") String id);
}