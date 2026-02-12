import 'package:tracking_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class ChangePasswordStates {
  final BaseState<ChangePasswordEntity>? changePasswordState;

const  ChangePasswordStates({this.changePasswordState});
  ChangePasswordStates copyWith({
    BaseState<ChangePasswordEntity>? changePasswordState,
  }) {
    return ChangePasswordStates(
     changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }
}