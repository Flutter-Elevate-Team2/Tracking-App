import 'package:json_annotation/json_annotation.dart';

part 'driver.g.dart';

@JsonSerializable()
class Driver {
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
  String? password;
  String? gender;
  String? phone;
  String? photo;
  String? role;
  DateTime? createdAt;

  Driver({
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
    this.password,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return _$DriverFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DriverToJson(this);
}
