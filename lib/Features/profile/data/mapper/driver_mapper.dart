import 'package:tracking_app/Features/profile/data/models/edit_profile_response/edit_profile_response.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/edit_driver_entity.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';

extension DriverProfileMapper on DriverProfileResponse {
  DriverEntity toEntity() {
    final driverData = driver;

    return DriverEntity(
      id: driverData?.id ?? '',
      firstName: driverData?.firstName ?? '',
      lastName: driverData?.lastName ?? '',
      email: driverData?.email ?? '',
      phone: driverData?.phone ?? '',
      photo: driverData?.photo ?? '',
      role: driverData?.role ?? 'driver',
      gender: driverData?.gender ?? '',
      country: driverData?.country ?? '',
      vehicleType: driverData?.vehicleType ?? '',
      vehicleNumber: driverData?.vehicleNumber ?? '',
      vehicleLicense: driverData?.vehicleLicense ?? '',
      nid: driverData?.nid ?? '',
      nidImg: driverData?.nidImg ?? '',
    );
  }
}
// extension EditDriverMapper on EditProfileResponse{
//   EditDriverEntity toEntity() {
//        final driverData = driver;
//     return EditDriverEntity(
//       id: driverData?.id ?? '',
//       firstName: driverData?.firstName ?? '',
//       lastName: driverData?.lastName ?? '',
//       email: driverData?.email ?? '',
//       phone: driverData?.phone ?? '',
//       photoUrl: driverData?.photo ?? '',
//       role: driverData?.role ?? 'driver',
//        gender: driverData?.gender ?? '',
// );
//   }
// }
