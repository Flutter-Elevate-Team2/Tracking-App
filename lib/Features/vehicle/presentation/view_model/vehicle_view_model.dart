import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/vehicle/domain/use_cases/get_all_vehicles_use_case.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_events.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_states.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

@injectable
class VehicleViewModel extends Cubit<VehicleStates> {
  VehicleViewModel(this._getAllVehiclesUseCase) : super(VehicleStates());

  final GetAllVehiclesUseCase _getAllVehiclesUseCase;

  void doIntent(VehicleEvents event) {
    if (event is GetAllVehiclesEvent) {
      _getAllVehicles();
    } else if (event is SelectVehicleEvent) {
      _selectVehicle(event.vehicleId);
    }
  }

  Future<void> _getAllVehicles() async {
    emit(state.copyWith(vehiclesState: BaseState(isLoading: true)));

    final result = await _getAllVehiclesUseCase.call();

    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(
            vehiclesState: BaseState(isLoading: false, data: result.data)));
        break;

      case ErrorResponse():
        emit(state.copyWith(
            vehiclesState: BaseState(
                isLoading: false, errorMessage: result.errorMessage)));
        break;
    }
  }

  void _selectVehicle(String vehicleId) {
    final vehicle = state.vehiclesState!.data
        ?.firstWhere((element) => element.id == vehicleId);
    emit(state.copyWith(selectedVehicle: vehicle));
  }
}
