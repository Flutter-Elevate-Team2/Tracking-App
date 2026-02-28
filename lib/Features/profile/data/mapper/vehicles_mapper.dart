import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';

extension VehiclesMapper on VehiclesResponse {
  List<VehicleEntity> toEntity() {
    return vehicles
            ?.map(
              (e) => VehicleEntity(
                id: e.id ?? '',
                type: e.type ?? '',
                image: e.image ?? '',
              ),
            )
            .toList() ??
        [];
  }
}
