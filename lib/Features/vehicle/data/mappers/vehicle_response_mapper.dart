import 'package:tracking_app/Features/vehicle/data/mappers/vehicle_mapper.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';

extension VehicleResponseMapper on VehicleResponse {
  VehicleEntity toEntity() {
    return vehicle!.toEntity();

  }
}

