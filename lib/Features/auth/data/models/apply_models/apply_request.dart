import 'dart:io';

class ApplyRequest {
  final String country;
  final String firstName;
  final String lastName;
  final String vehicleType;
  final String vehicleNumber;
  final String nid;
  final String email;
  final String password;
  final String rePassword;
  final String gender;
  final String phone;

  final File vehicleLicense;
  final File nidImg;

  ApplyRequest({
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.nid,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.gender,
    required this.phone,
    required this.vehicleLicense,
    required this.nidImg,
  });
}
