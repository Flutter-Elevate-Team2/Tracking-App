abstract class VehicleEvents {}

class GetAllVehiclesEvent extends VehicleEvents {}

class SelectVehicleEvent extends VehicleEvents {
  final String vehicleId;
  SelectVehicleEvent(this.vehicleId);
}
