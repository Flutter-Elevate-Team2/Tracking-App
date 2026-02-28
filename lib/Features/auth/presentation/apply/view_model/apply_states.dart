import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class ApplyStates {

  final BaseState<ApplyEntity>? applyState;

  ApplyStates({this.applyState});
  ApplyStates copyWith({
    BaseState<ApplyEntity>? applyState,
  }) {
    return ApplyStates(
      applyState: applyState ?? this.applyState,
    );
  }
}