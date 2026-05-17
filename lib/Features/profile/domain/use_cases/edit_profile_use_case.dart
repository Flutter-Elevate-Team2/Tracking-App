import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
@injectable
class EditProfileUseCase {
  final ProfileRepoContract _repo;
  EditProfileUseCase(this._repo);
  Future<BaseResponse<DriverEntity>> call(EditProfileRequest request) async {
    return await _repo.editProfile(request);
  }
  
}