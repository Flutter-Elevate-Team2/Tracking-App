import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/lib/Features/profile/data/models/logout_response.dart';
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
}
