import 'dart:io';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';
import 'package:tracking_app/Features/profile/data/models/logout_response.dart';
import 'package:tracking_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<DriverProfileResponse> editProfile(EditProfileRequest request);
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
   Future<UploadPhotoResponse> uploadPhoto(File file);
    Future<DriverProfileResponse> getDriverProfile();
  Future<LogoutResponse> logout();
  Future<DriverProfileResponse> editDriverProfile({
    String? vehicleType,
    String? vehicleNumber,
    File? vehicleLicense,
  });
  Future<VehiclesResponse> getVehicles();

}