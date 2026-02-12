
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class ProfileStates {
  final BaseState<DriverEntity>? profileState;
  final BaseState<DriverEntity>? editVehicleState;
  final BaseState<void>? logoutState;

  const ProfileStates({
    this.profileState,
    this.editVehicleState,
    this.logoutState,
  });

  ProfileStates copyWith({
    BaseState<DriverEntity>? profileState,
    BaseState<DriverEntity>? editVehicleState,
    BaseState<void>? logoutState,
  }) {
    return ProfileStates(
      profileState: profileState ?? this.profileState,
      editVehicleState: editVehicleState ?? this.editVehicleState,
      logoutState: logoutState ?? this.logoutState,
    );
  }
}
