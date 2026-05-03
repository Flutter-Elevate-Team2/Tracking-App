import 'package:tracking_app/Features/track_order/domain/entities/order_item_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';

class OrderTrackingEntity {
  final String orderNumber;
  final DateTime updatedAt;
  final String status;
  final double totalPrice;
  final String paymentType;
  final StoreEntity store;
  final UserEntity user;
  final List<OrderItemEntity> items;
  final String shippingAddress;

  OrderTrackingEntity({
    required this.orderNumber,
    required this.updatedAt,
    required this.status,
    required this.totalPrice,
    required this.paymentType,
    required this.store,
    required this.user,
    required this.items,
    required this.shippingAddress,
  });
}
