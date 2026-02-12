
import 'dart:io';

sealed class ProfileEvents {}

class GetDriverProfileEvent extends ProfileEvents {}

class LogoutEvent extends ProfileEvents {}

class EditVehicleEvent extends ProfileEvents {
  final String? vehicleType;
  final String? vehicleNumber;
  final File? vehicleLicense;

  EditVehicleEvent({
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
  });
}
