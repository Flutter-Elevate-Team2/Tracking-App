import 'package:json_annotation/json_annotation.dart';

part 'vehicles_response.g.dart';

@JsonSerializable()
class VehiclesResponse {
  String? message;
  MetadataModel? metadata;
  List<VehicleModel>? vehicles;

  VehiclesResponse({this.message, this.metadata, this.vehicles});

  factory VehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$VehiclesResponseFromJson(json);
}

@JsonSerializable()
class MetadataModel {
  int? currentPage;
  int? totalPages;
  int? limit;
  int? totalItems;

  MetadataModel({
    this.currentPage,
    this.totalPages,
    this.limit,
    this.totalItems,
  });

  factory MetadataModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataModelFromJson(json);
}

@JsonSerializable()
class VehicleModel {
  @JsonKey(name: '_id')
  String? id;
  String? type;
  String? image;
  String? createdAt;
  String? updatedAt;

  VehicleModel({
    this.id,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);
}
