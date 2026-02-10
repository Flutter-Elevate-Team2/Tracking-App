import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class ProfileRepoContract {
  Future<BaseResponse<DriverEntity>> getDriverProfile();
}
