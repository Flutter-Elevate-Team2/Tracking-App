import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/Features/vehicle/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';

part 'all_vehicles_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AllVehiclesResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "metadata")
  final Metadata? metadata;
  @JsonKey(name: "vehicles")
  final List<Vehicle>? vehicles;

  AllVehiclesResponse ({
    this.message,
    this.metadata,
    this.vehicles,
  });

  factory AllVehiclesResponse.fromJson(Map<String, dynamic> json) {
    return _$AllVehiclesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AllVehiclesResponseToJson(this);
  }
}

