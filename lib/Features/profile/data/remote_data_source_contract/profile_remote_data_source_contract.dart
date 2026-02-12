import 'dart:io';

import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/logout_response.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<DriverProfileResponse> getDriverProfile();
  Future<LogoutResponse> logout();
  Future<DriverProfileResponse> editDriverProfile({
    String? vehicleType,
    String? vehicleNumber,
    File? vehicleLicense,
  });
  Future<VehiclesResponse> getVehicles();
}
