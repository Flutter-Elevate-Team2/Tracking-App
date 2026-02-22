import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

part 'order_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class OrderApi {
  @factoryMethod
  factory OrderApi(Dio dio) = _OrderApi;

  @GET(ApiConstants.driverOrders)
  Future<DriverOrdersResponse> getAllDriverOrders();

  @PUT("${ApiConstants.updateOrderState}{id}")
  Future<UpdateOrderResponse> updateOrderState(
    @Path("id") String itemId,
    @Body() String orderState,
  );


}
