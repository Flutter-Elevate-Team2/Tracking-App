import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/api/api_client/api_client.dart';
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
