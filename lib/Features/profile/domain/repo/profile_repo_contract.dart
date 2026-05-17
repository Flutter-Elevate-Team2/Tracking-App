import 'dart:io';

import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class ProfileRepoContract {
  Future<BaseResponse<DriverEntity>> editProfile(EditProfileRequest request);
  Future<BaseResponse<ChangePasswordEntity>> changePassword(ChangePasswordRequest request);
   Future<BaseResponse<String>> uploadPhoto(File file);
    Future<BaseResponse<DriverEntity>> getDriverProfile();
  Future<BaseResponse<String>> logout();
  Future<BaseResponse<DriverEntity>> editDriverProfile({
    String? vehicleType,
    String? vehicleNumber,
    File? vehicleLicense,
  });
  Future<BaseResponse<List<VehicleEntity>>> getVehicles();
}

