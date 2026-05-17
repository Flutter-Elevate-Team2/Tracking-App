import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

class HomeState extends Equatable {
  final BaseState<List<OrderEntity>>? ordersState;
  final BaseState<OrderEntity>? acceptOrderState;
  final String? acceptingOrderId;

  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginationLoading;

  const HomeState({
    this.ordersState = const BaseState(),
    this.acceptOrderState = const BaseState(),
    this.acceptingOrderId,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isPaginationLoading = false,
  });

  HomeState copyWith({
    BaseState<List<OrderEntity>>? ordersState,
    BaseState<OrderEntity>? acceptOrderState,
    String? acceptingOrderId,
    bool clearAcceptingOrderId = false,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginationLoading,
  }) {
    return HomeState(
      ordersState: ordersState ?? this.ordersState,
      acceptOrderState: acceptOrderState ?? this.acceptOrderState,
      acceptingOrderId: clearAcceptingOrderId
          ? null
          : (acceptingOrderId ?? this.acceptingOrderId),
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
    );
  }

  @override
  List<Object?> get props => [
    ordersState,
    acceptOrderState,
    acceptingOrderId,
    currentPage,
    hasReachedMax,
    isPaginationLoading,
  ];
}
