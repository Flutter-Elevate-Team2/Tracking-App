import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';

class VehicleStates extends Equatable {
  final BaseState<List<VehicleEntity>>? vehiclesState;
  final VehicleEntity? selectedVehicle;

  const VehicleStates({
    this.vehiclesState ,
    this.selectedVehicle,
  });

  VehicleStates copyWith({
    BaseState<List<VehicleEntity>>? vehiclesState,
    VehicleEntity? selectedVehicle,
  }) {
    return VehicleStates(
      vehiclesState: vehiclesState ?? this.vehiclesState,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
    );
  }
  @override
  List<Object?> get props =>  [vehiclesState, selectedVehicle];

}
