import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class ProfileStates {
  final BaseState<DriverEntity>? profileState;
  final BaseState<void>? logoutState;

  const ProfileStates({
    this.profileState,
    this.logoutState,
  });

  ProfileStates copyWith({
    BaseState<DriverEntity>? profileState,
    BaseState<void>? logoutState,
  }) {
    return ProfileStates(
      profileState: profileState ?? this.profileState,
      logoutState: logoutState ?? this.logoutState,
    );
  }
}
