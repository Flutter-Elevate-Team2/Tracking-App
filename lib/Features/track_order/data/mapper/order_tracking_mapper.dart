import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_item_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';

extension OrderTrackingMapper on OrderTrackingFirebaseModel {
  OrderTrackingEntity toEntity() {
    return OrderTrackingEntity(
      orderNumber: orderData['orderNumber']?.toString() ?? '',
      updatedAt: updatedAt ?? DateTime.now(),
      status: status,
      totalPrice: (orderData['totalPrice'] as num?)?.toDouble() ?? 0.0,
      paymentType: orderData['paymentType'] ?? '',
      store: StoreEntity(
        storeName: orderData['storeName'] ?? '',
        storeAddress: orderData['storeAddress'] ?? '',
        storeImage: orderData['storeImage'] ?? '',
        storePhone: orderData['storePhone'] ?? '',
      ),
      user: UserEntity(
        userName: userData['userName'] ?? '',
        userImage: userData['userImage'] ?? '',
        userPhone: userData['userPhone'] ?? '',
        deviceToken: userData['deviceToken'] ?? '',
      ),
      items: (orderData['items'] as List<dynamic>? ?? []).map((item) {
        return OrderItemEntity(
          name: item['name'] ?? '',
          price: item['price']?.toString() ?? '0',
          quantity: (item['quantity'] as num?)?.toInt() ?? 1,
        );
      }).toList(),
      shippingAddress: _formatShippingAddress(orderData['shippingAddress']),
    );
  }

  String _formatShippingAddress(dynamic shipping) {
    if (shipping is Map) {
      final street = shipping['street']?.toString() ?? '';
      final city = shipping['city']?.toString() ?? '';
      if (street.isNotEmpty && city.isNotEmpty) {
        return '$street, $city';
      }
      return street.isNotEmpty ? street : city;
    }
    return shipping?.toString() ?? '';
  }
}
