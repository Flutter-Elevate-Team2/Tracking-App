import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class ProfileStates {
  final BaseState<DriverEntity>? profileState;

  const ProfileStates({this.profileState});

  ProfileStates copyWith({
    BaseState<DriverEntity>? profileState,
  }) {
    return ProfileStates(
      profileState: profileState ?? this.profileState,
    );
  }
}
