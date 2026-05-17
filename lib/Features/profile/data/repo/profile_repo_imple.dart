import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/data/mapper/change_password_mapper.dart';
import 'package:tracking_app/Features/profile/data/mapper/driver_mapper.dart';
import 'package:tracking_app/Features/profile/data/mapper/driver_profile_mapper.dart';
import 'package:tracking_app/Features/profile/data/mapper/vehicles_mapper.dart';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/logout_response.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';
import 'package:tracking_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:tracking_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepoImple with ApiExecutionMixin implements ProfileRepoContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  ProfileRepoImple(this._remoteDataSource);

  @override
  Future<BaseResponse<ChangePasswordEntity>> changePassword(ChangePasswordRequest request) {
   return execute<ChangePasswordResponse,ChangePasswordEntity>(
    action: ()async => await _remoteDataSource.changePassword(request), 
    mapper: (response) => response.toEntity());
  }

  @override
  Future<BaseResponse<DriverEntity>> editProfile(EditProfileRequest request) {
    return execute<EditProfileResponse,DriverEntity>(
      action: ()async => await _remoteDataSource.editProfile(request),
      mapper: (response) => response.toEntity());
  }

  @override
  Future<BaseResponse<String>> uploadPhoto(File file) async {
    return execute<UploadPhotoResponse, String>(
      action: () async => await _remoteDataSource.uploadPhoto(file),
      mapper: (response) => response.message,
    );
  }

  @override
  Future<BaseResponse<DriverEntity>> getDriverProfile() async {
    return execute<DriverProfileResponse, DriverEntity>(
      action: () async => await _remoteDataSource.getDriverProfile(),
      mapper: (response) => response.toEntity(),
    );
  }

  @override
  Future<BaseResponse<String>> logout() async {
    return execute<LogoutResponse, String>(
      action: () async => await _remoteDataSource.logout(),
      mapper: (response) => response.message,
    );
  }

  @override
  Future<BaseResponse<DriverEntity>> editDriverProfile({
    String? vehicleType,
    String? vehicleNumber,
    File? vehicleLicense,
  }) async {
    return execute<DriverProfileResponse, DriverEntity>(
      action: () async => await _remoteDataSource.editDriverProfile(
        vehicleType: vehicleType,
        vehicleNumber: vehicleNumber,
        vehicleLicense: vehicleLicense,
      ),
      mapper: (response) => response.toEntity(),
    );
  }

  @override
  Future<BaseResponse<List<VehicleEntity>>> getVehicles() async {
    return execute<VehiclesResponse, List<VehicleEntity>>(
      action: () async => await _remoteDataSource.getVehicles(),
      mapper: (response) => response.toEntity(),
    );
  }
}
