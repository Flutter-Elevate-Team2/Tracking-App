import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';

  extension VehicleMapper on Vehicle {
  VehicleEntity toEntity() {
    return VehicleEntity(
        id: id,
      type: type,
      image: image,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }
}
