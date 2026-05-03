import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class GetDriverProfileUseCase {
  final ProfileRepoContract _repo;

  @factoryMethod
  GetDriverProfileUseCase(this._repo);

  Future<BaseResponse<DriverEntity>> call() async {
    return await _repo.getDriverProfile();
  }
}
