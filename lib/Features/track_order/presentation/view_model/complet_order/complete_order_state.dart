import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/track_order/domain/entities/complete_order_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class CompleteOrderState extends Equatable {
  final BaseState<CompleteOrderEntity> completeOrderState;

  const CompleteOrderState({this.completeOrderState = const BaseState()});

  CompleteOrderState copyWith({
    BaseState<CompleteOrderEntity>? completeOrderState,
  }) {
    return CompleteOrderState(
      completeOrderState: completeOrderState ?? this.completeOrderState,
    );
  }

  @override
  List<Object?> get props => [completeOrderState];
}
