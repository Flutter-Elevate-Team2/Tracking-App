import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';

abstract class VehicleRemoteDataSourceContract {
  Future<VehicleResponse> getVehicle(String vehicleId);
  Future<AllVehiclesResponse> getAllVehicles();

}
