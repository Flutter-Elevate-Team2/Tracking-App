import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class HomeState extends Equatable {
  final BaseState<List<OrderEntity>>? ordersState;
  final BaseState<OrderEntity>? acceptOrderState;

  const HomeState({
    this.ordersState = const BaseState(),
    this.acceptOrderState = const BaseState(),
  });

  HomeState copyWith({
    BaseState<List<OrderEntity>>? ordersState,
    BaseState<OrderEntity>? acceptOrderState,
  }) {
    return HomeState(
      ordersState: ordersState ?? this.ordersState,
      acceptOrderState: acceptOrderState ?? this.acceptOrderState,
    );
  }

  @override
  List<Object?> get props => [ordersState, acceptOrderState];
}
