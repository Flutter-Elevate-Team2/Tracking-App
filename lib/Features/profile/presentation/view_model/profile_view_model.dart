import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/edit_vehicle_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_vehicles_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/logout_use_case.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileStates> {
  ProfileViewModel(
    this._getDriverProfileUseCase,
    this._logoutUseCase,
    this._editVehicleUseCase,
    this._getVehiclesUseCase,
    this._sessionController,
  ) : super(const ProfileStates());

  final GetDriverProfileUseCase _getDriverProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final EditVehicleUseCase _editVehicleUseCase;
  final GetVehiclesUseCase _getVehiclesUseCase;
  final SessionController _sessionController;

  void doIntent(ProfileEvents event) {
    switch (event) {
      case GetDriverProfileEvent():
        _getProfile();
        break;
      case LogoutEvent():
        _logout();
        break;
      case EditVehicleEvent():
        _editVehicle(event);
        break;
      case GetVehiclesEvent():
        _getVehicles();
        break;
    }
  }

  Future<void> _getVehicles() async {
    emit(state.copyWith(vehiclesState: BaseState(isLoading: true)));

    final result = await _getVehiclesUseCase.call();

    switch (result) {
      case SuccessResponse():
        emit(
          state.copyWith(
            vehiclesState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;

      case ErrorResponse():
        emit(
          state.copyWith(
            vehiclesState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _editVehicle(EditVehicleEvent event) async {
    emit(state.copyWith(editVehicleState: BaseState(isLoading: true)));

    final result = await _editVehicleUseCase.call(
      vehicleType: event.vehicleType,
      vehicleNumber: event.vehicleNumber,
      vehicleLicense: event.vehicleLicense,
    );

    switch (result) {
      case SuccessResponse():
        _sessionController.saveUser(result.data);
        emit(
          state.copyWith(
            editVehicleState: BaseState(isLoading: false, data: result.data),
            profileState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;

      case ErrorResponse():
        emit(
          state.copyWith(
            editVehicleState: BaseState(
              isLoading: false,
              errorMessage: result.errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(profileState: BaseState(isLoading: true)));

    final result = await _getDriverProfileUseCase.call();

    switch (result) {
      case SuccessResponse():
        _sessionController.saveUser((result as SuccessResponse).data);

        emit(
          state.copyWith(
            profileState: BaseState(isLoading: false, data: result.data),
          ),
        );
        break;

      case ErrorResponse():
        emit(
          state.copyWith(
            profileState: BaseState(
              isLoading: false,
              errorMessage: (result as ErrorResponse).errorMessage,
            ),
          ),
        );
        break;
    }
  }

  Future<void> _logout() async {
    if (isClosed) return;
    emit(state.copyWith(logoutState: BaseState(isLoading: true)));

    final result = await _logoutUseCase.call();

    if (isClosed) return;

    switch (result) {
      case SuccessResponse():
        await _sessionController.notifyLogout(SessionEndReason.logout);

        emit(
          state.copyWith(logoutState: BaseState(isLoading: false, data: null)),
        );
        break;

      case ErrorResponse():
        emit(
          state.copyWith(
            logoutState: BaseState(
              isLoading: false,
              errorMessage: (result as ErrorResponse).errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
