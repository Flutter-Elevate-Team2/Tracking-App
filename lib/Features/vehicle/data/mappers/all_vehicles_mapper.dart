import 'package:tracking_app/Features/vehicle/data/mappers/vehicle_mapper.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';

extension AllVehiclesMapper on AllVehiclesResponse {
  List<VehicleEntity> toEntity() {
    return vehicles!.map((e) => e.toEntity()).toList();
  }
}
