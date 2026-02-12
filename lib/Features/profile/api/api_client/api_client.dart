import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/logout_response.dart';
import 'package:tracking_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

part 'api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ProfileApi {
  @factoryMethod
  factory ProfileApi(Dio dio) = _ProfileApi;

  @GET(ApiConstants.getDriverProfile)
  Future<DriverProfileResponse> getDriverProfile();

  @GET(ApiConstants.logout)
  Future<LogoutResponse> logout();

  @PUT(ApiConstants.editDriverProfile)
  @MultiPart()
  Future<DriverProfileResponse> editDriverProfile({
    @Part(name: "vehicleType") String? vehicleType,
    @Part(name: "vehicleNumber") String? vehicleNumber,
    @Part(name: "vehicleLicense") File? vehicleLicense,
  });

  @GET(ApiConstants.vehicles)
  Future<VehiclesResponse> getVehicles();
  @PUT(ApiConstants.editDriverProfile)
  Future<EditProfileResponse> editProfile(@Body() EditProfileRequest request);
  @PATCH(ApiConstants.changeDriverPassword)
  Future<ChangePasswordResponse> changePassword(@Body() ChangePasswordRequest request);
  @PUT(ApiConstants.uploadDriverPhoto)
  @MultiPart() 
  Future<UploadPhotoResponse> uploadPhoto(
    @Part(name: "photo") File photo,
     
  );
  
}
