import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';

sealed class HomeEvent {}

class GetPendingOrdersEvent extends HomeEvent {}

class AcceptOrderEvent extends HomeEvent {
  final OrderEntity order;
  AcceptOrderEvent(this.order);
}

class RejectOrderEvent extends HomeEvent {
  final String orderId;
  RejectOrderEvent(this.orderId);
}
