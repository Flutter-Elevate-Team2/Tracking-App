import 'package:equatable/equatable.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';

class MyOrdersState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<DriverOrdersEntity> allOrders;
  final int completedOrdersCount;
  final int canceledOrdersCount;

  const MyOrdersState({
    this.isLoading = false,
    this.errorMessage,
    this.allOrders = const [],
    this.completedOrdersCount = 0,
    this.canceledOrdersCount = 0,
  });

  MyOrdersState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DriverOrdersEntity>? allOrders,
    int? completedOrdersCount,
    int? canceledOrdersCount,
  }) {
    return MyOrdersState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      allOrders: allOrders ?? this.allOrders,
      completedOrdersCount: completedOrdersCount ?? this.completedOrdersCount,
      canceledOrdersCount: canceledOrdersCount ?? this.canceledOrdersCount,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    allOrders,
    completedOrdersCount,
    canceledOrdersCount,
  ];
}