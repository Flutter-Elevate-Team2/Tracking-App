import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/vehicle/api/api_client/vehicle_api.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';
import 'package:tracking_app/Features/vehicle/data/vehicle_data_source_contract/vehicle_remote_data_source_contract.dart';

@Injectable(as: VehicleRemoteDataSourceContract)
class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSourceContract {
  final VehicleApi _vehicleApi;

  VehicleRemoteDataSourceImpl(this._vehicleApi);

  @override
  Future<VehicleResponse> getVehicle(String vehicleId) async {
    return await _vehicleApi.getVehicle(vehicleId);
  }

  @override
  Future<AllVehiclesResponse> getAllVehicles() async {
    return await _vehicleApi.getAllVehicles();
  }

}
