import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/api/api_cleint/api_client.dart';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/logout_response.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';
import 'package:tracking_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImple implements ProfileRemoteDataSourceContract {
  final ProfileApi _api;

  @factoryMethod
  ProfileRemoteDataSourceImple(this._api);

  @override
  Future<EditProfileResponse> editProfile(EditProfileRequest request) async {
    return await _api.editProfile(request);
  }

  @override
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) {
    return _api.changePassword(request);
  }

  @override
  Future<UploadPhotoResponse> uploadPhoto(File file) async {
    return await _api.uploadPhoto(file);
  }

  @override
  Future<DriverProfileResponse> getDriverProfile() async {
    return await _api.getDriverProfile();
  }

  @override
  Future<LogoutResponse> logout() async {
    return await _api.logout();
  }

  @override
  Future<DriverProfileResponse> editDriverProfile({
    String? vehicleType,
    String? vehicleNumber,
    File? vehicleLicense,
  }) async {
    return await _api.editDriverProfile(
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
    );
  }

  @override
  Future<VehiclesResponse> getVehicles() async {
    return await _api.getVehicles();
  }
}
