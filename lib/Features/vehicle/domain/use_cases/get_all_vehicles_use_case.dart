import 'package:tracking_app/Features/vehicle/domain/vehicle_repo_contract/vehicle_repo_contract.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllVehiclesUseCase {
  final VehicleRepoContract _vehicleRepo;

  GetAllVehiclesUseCase(this._vehicleRepo);

  Future<BaseResponse<List<VehicleEntity>>> call() async {
    return await _vehicleRepo.getAllVehicles();
  }
}