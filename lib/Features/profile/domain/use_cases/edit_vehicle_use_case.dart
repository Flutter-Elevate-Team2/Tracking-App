
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class EditVehicleUseCase {
  final ProfileRepoContract _repo;

  EditVehicleUseCase(this._repo);

  Future<BaseResponse<DriverEntity>> call({
    String? vehicleType,
    String? vehicleNumber,
    File? vehicleLicense,
  }) async {
    return await _repo.editDriverProfile(
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );
  }
}
