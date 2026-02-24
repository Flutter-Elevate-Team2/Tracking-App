import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
// coverage:ignore-file

part 'vehicle_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class VehicleApi {
  @factoryMethod
  factory VehicleApi(Dio dio) = _VehicleApi;

  /// === Vehicle Endpoint ===

  @GET(ApiConstants.vehicle)
  Future<VehicleResponse> getVehicle(@Path("vehicleId") String vehicleId);

  /// === All Vehicles Endpoints ===
  @GET(ApiConstants.vehicle)
  Future<AllVehiclesResponse> getAllVehicles();

}
