import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';

part 'vehicle_response.g.dart';

@JsonSerializable(explicitToJson: true)
class VehicleResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "vehicle")
  final Vehicle? vehicle;

  VehicleResponse ({
    this.message,
    this.vehicle,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return _$VehicleResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VehicleResponseToJson(this);
  }
}


