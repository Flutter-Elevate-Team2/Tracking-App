import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/track_order/data/mapper/order_tracking_mapper.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';

void main() {
  group('OrderTrackingMapper Test', () {
    final now = DateTime.now();

    test('toEntity should correctly map OrderTrackingFirebaseModel to OrderTrackingEntity', () {
      // Arrange
      final firebaseModel = OrderTrackingFirebaseModel(
        updatedAt: now,
        status: 'on_the_way',
        orderData: {
          'orderNumber': 12345,
          'totalPrice': 150.5,
          'paymentType': 'Cash',
          'shippingAddress': {'street': '90 St', 'city': 'New Cairo'}
        },
        storeData: {
          'storeName': 'Buffalo Burger',
          'storeAddress': 'Cairo',
          'storeImage': 'image_url',
          'storePhone': '0123456',
        },
        userData: {
          'userName': 'Nagham',
          'userImage': 'user_url',
          'userPhone': '0111222',
          'deviceToken': 'token_123',
        },
        orderItems: [
          {
            'productTitle': 'Burger',
            'productPrice': 100,
            'productQuantity': 2,
            'productImage': 'burger_url',
          }
        ], driverData: {}, trackingLocation: {},
      );

      // Act
      final entity = firebaseModel.toEntity();

      // Assert
      expect(entity, isA<OrderTrackingEntity>());
      expect(entity.orderNumber, '12345');
      expect(entity.status, 'on_the_way');
      expect(entity.totalPrice, 150.5);
      expect(entity.shippingAddress, '90 St, New Cairo');

       expect(entity.store.storeName, 'Buffalo Burger');

       expect(entity.user.userName, 'Nagham');

       expect(entity.items.length, 1);
      expect(entity.items[0].name, 'Burger');
      expect(entity.items[0].quantity, 2);
    });

    test('should handle null/missing fields gracefully using default values', () {
      // Arrange
      final firebaseModel = OrderTrackingFirebaseModel(
        updatedAt: null,
        status: 'pending',
        orderData: {},
        storeData: {},
        userData: {},
        orderItems: [], driverData: {}, trackingLocation: {},
      );

      // Act
      final entity = firebaseModel.toEntity();

      // Assert
      expect(entity.orderNumber, '');
      expect(entity.totalPrice, 0.0);
      expect(entity.paymentType, '');
      expect(entity.items, isEmpty);
      expect(entity.updatedAt, isNotNull);
    });

    test('_formatShippingAddress should return formatted string when city and street exist', () {
      // Arrange
      final modelWithAddress = OrderTrackingFirebaseModel(
        orderData: {
          'shippingAddress': {'street': 'Zayed', 'city': 'Giza'}
        },
        storeData: {}, userData: {}, orderItems: [], status: '', driverData: {}, trackingLocation: {},
      );

      // Act
      final entity = modelWithAddress.toEntity();

      // Assert
      expect(entity.shippingAddress, 'Zayed, Giza');
    });
  });
}