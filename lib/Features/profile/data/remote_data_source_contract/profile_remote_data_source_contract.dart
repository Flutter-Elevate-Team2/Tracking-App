import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/lib/Features/profile/data/models/logout_response.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<DriverProfileResponse> getDriverProfile();
  Future<LogoutResponse> logout();
}
