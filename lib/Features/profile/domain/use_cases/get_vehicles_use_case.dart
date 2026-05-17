import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class GetVehiclesUseCase {
  final ProfileRepoContract _repo;

  GetVehiclesUseCase(this._repo);

  Future<BaseResponse<List<VehicleEntity>>> call() async {
    return await _repo.getVehicles();
  }
}
