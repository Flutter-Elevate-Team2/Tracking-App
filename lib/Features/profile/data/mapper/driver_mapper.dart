import 'package:tracking_app/Features/profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';


extension DriverMapper on EditProfileResponse{
  DriverEntity toEntity() {
       final driverData = driver;
    return DriverEntity(
      id: driverData?.id ?? '',
      firstName: driverData?.firstName ?? '',
      lastName: driverData?.lastName ?? '',
      email: driverData?.email ?? '',
      phone: driverData?.phone ?? '',
      photoUrl: driverData?.photo ?? '',
      role: driverData?.role ?? 'driver',
       gender: driverData?.gender ?? '',
);
  }
}