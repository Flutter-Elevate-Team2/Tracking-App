import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_item_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';

class OrderTrackingEntity {
  final String id;
  final String orderNumber;
  final DateTime updatedAt;
  final String status;
  final double totalPrice;
  final String paymentType;
  final StoreEntity store;
  final UserEntity user;
  final List<OrderItemEntity> items;
  final String shippingAddress;
  final TrackingLocationEntity trackingLocation;
  final UserLocationEntity userLocationEntity;

  OrderTrackingEntity({
    required this.id,
    required this.orderNumber,
    required this.updatedAt,
    required this.status,
    required this.totalPrice,
    required this.paymentType,
    required this.store,
    required this.user,
    required this.items,
    required this.shippingAddress,
    required this.trackingLocation,
    required this.userLocationEntity,
  });
}
