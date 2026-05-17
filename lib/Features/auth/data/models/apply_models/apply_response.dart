import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/driver_dto.dart';

part 'apply_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ApplyResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "driver")
  final DriverDto? driver;
  @JsonKey(name: "token")
  final String? token;

  ApplyResponse({this.message, this.driver, this.token});

  factory ApplyResponse.fromJson(Map<String, dynamic> json) {
    return _$ApplyResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ApplyResponseToJson(this);
  }
}
