import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class TrackOrderStatusState extends Equatable {
  final BaseState<OrderTrackingEntity>? orderState;
  final BaseState<void>? updateStatusState;

  const TrackOrderStatusState({
    this.orderState = const BaseState(),
    this.updateStatusState = const BaseState(),
  });

  TrackOrderStatusState copyWith({
    BaseState<OrderTrackingEntity>? orderState,
    BaseState<void>? updateStatusState,
  }) {
    return TrackOrderStatusState(
      orderState: orderState ?? this.orderState,
      updateStatusState: updateStatusState ?? this.updateStatusState,
    );
  }

  @override
  List<Object?> get props => [orderState, updateStatusState];
}
