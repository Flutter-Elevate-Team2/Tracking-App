import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class VehicleRepoContract {

  Future<BaseResponse<List<VehicleEntity>>> getAllVehicles();

  Future<BaseResponse<VehicleEntity>> getVehicle(String id);

}
