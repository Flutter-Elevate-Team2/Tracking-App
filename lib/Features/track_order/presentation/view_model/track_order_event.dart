import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';

sealed class TrackOrderStatusEvent {}

class FetchOrderDetailsEvent extends TrackOrderStatusEvent {
  final String orderId;
  FetchOrderDetailsEvent(this.orderId);
}
class SyncOrderWithBackendEvent extends TrackOrderStatusEvent {
  final String orderId;
  SyncOrderWithBackendEvent(this.orderId);
}

class UpdateOrderStatusEvent extends TrackOrderStatusEvent {
  final String orderId;
  final OrderStatus status;
  final String userToken;
  final String title;
  UpdateOrderStatusEvent({
    required this.orderId,
    required this.status,
    required this.userToken,
    required this.title,
  });
}
