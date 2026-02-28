import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_item_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/store_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/tracking_location_entity.dart';
import 'package:tracking_app/Features/track_order/domain/entities/user_entity.dart';

extension OrderTrackingMapper on OrderTrackingFirebaseModel {
  OrderTrackingEntity toEntity() {
    return OrderTrackingEntity(
      id: orderData['orderId']?.toString() ?? '',
      orderNumber: orderData['orderNumber']?.toString() ?? '',
      updatedAt: updatedAt ?? DateTime.now(),
      status: status,
      totalPrice: (orderData['totalPrice'] as num?)?.toDouble() ?? 0.0,
      paymentType: orderData['paymentType'] ?? '',
      store: StoreEntity(
        storeName: storeData['storeName'] ?? '',
        storeAddress: storeData['storeAddress'] ?? '',
        storeImage: storeData['storeImage'] ?? '',
        storePhone: storeData['storePhone'] ?? '',
        storeLat: (storeData['lat'] as num?)?.toDouble() ?? 28,
        storeLong: (storeData['long'] as num?)?.toDouble() ?? 30,
      ),
      user: UserEntity(
        userName: userData['userName'] ?? '',
        userImage: userData['userImage'] ?? '',
        userPhone: userData['userPhone'] ?? '',
        deviceToken: userData['deviceToken'] ?? '',
      ),
      items: orderItems.map((item) {
        return OrderItemEntity(
          name: item['productTitle'] ?? '',
          price: item['productPrice']?.toString() ?? '0',
          quantity: (item['productQuantity'] as num?)?.toInt() ?? 1,
          image: item['productImage'] ?? '',
        );
      }).toList(),
      shippingAddress: _formatShippingAddress(orderData['shippingAddress']),
      trackingLocation: TrackingLocationEntity(
        lat: trackingLocation['lat'],
        long: trackingLocation['long'],
      ),
      userLocationEntity: UserLocationEntity(
        lat: (orderData['shippingAddress']['location']['lat'] as num)
            .toDouble(),
        long: (orderData['shippingAddress']['location']['long'] as num)
            .toDouble(),
      ),
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
