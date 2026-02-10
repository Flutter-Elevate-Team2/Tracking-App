import 'package:json_annotation/json_annotation.dart';

part 'driver_profile_response.g.dart';

@JsonSerializable()
class DriverProfileResponse {
  String? message;
  DriverModel? driver;

  DriverProfileResponse({this.message, this.driver});

  factory DriverProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileResponseFromJson(json);
}

@JsonSerializable()
class DriverModel {
  @JsonKey(name: '_id')
  String? id;
  String? country;
  String? firstName;
  String? lastName;
  String? vehicleType;
  String? vehicleNumber;
  String? vehicleLicense;

  @JsonKey(name: 'NID')
  String? nid;

  @JsonKey(name: 'NIDImg')
  String? nidImg;

  String? email;
  String? gender;
  String? phone;
  String? photo;
  String? role;
  String? createdAt;

  DriverModel({
    this.id,
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);
}
