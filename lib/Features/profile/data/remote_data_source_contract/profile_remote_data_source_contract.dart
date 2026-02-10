import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<DriverProfileResponse> getDriverProfile();
}
