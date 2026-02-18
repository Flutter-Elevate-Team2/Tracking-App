import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/Features/home/data/models/orders_response_dto.dart';
import 'package:tracking_app/Features/home/data/models/start_order_response_dto.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

part 'home_api_client.g.dart';

@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio, {String baseUrl}) = _HomeApiClient;

  @GET(ApiConstants.pendingOrders)
  Future<OrdersResponseDto> getPendingOrders();

  @PUT("${ApiConstants.startOrder}{id}")
  Future<StartOrderResponseDto> startOrder(@Path("id") String id);
}
