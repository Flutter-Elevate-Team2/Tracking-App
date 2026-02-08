import 'package:json_annotation/json_annotation.dart';

import 'driver.dart';

part 'edit_profile_response.g.dart';

@JsonSerializable()
class EditProfileResponse {
  String? message;
  Driver? driver;

  EditProfileResponse({this.message, this.driver});

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return _$EditProfileResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EditProfileResponseToJson(this);
}
