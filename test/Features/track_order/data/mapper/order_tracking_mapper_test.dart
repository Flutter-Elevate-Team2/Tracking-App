import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';
import 'package:tracking_app/Features/track_order/data/mapper/order_tracking_mapper.dart';

void main() {
  group('OrderTrackingMapper Test', () {
    final now = DateTime.now();

    test(
      'toEntity: Success Path - should map all fields correctly with valid data',
      () {
        // Arrange
        final firebaseModel = OrderTrackingFirebaseModel(
          updatedAt: now,
          status: 'on_the_way',
          orderData: {
            'orderId': 'ID_123',
            'orderNumber': 12345,
            'totalPrice': 150.5,
            'paymentType': 'Visa',
            'shippingAddress': {
              'street': '90 St',
              'city': 'New Cairo',
              'location': {'lat': 30.0, 'long': 31.0},
            },
          },
          storeData: {'storeName': 'Buffalo Burger', 'lat': 29.0, 'long': 31.5},
          userData: {'userName': 'Nagham'},
          orderItems: [
            {
              'productTitle': 'Burger',
              'productPrice': 100,
              'productQuantity': 2,
            },
          ],
          trackingLocation: {'lat': 30.5, 'long': 31.8},
          driverData: {},
        );

        // Act
        final entity = firebaseModel.toEntity();

        // Assert
        expect(entity.id, 'ID_123');
        expect(entity.status, 'on_the_way');
        expect(entity.totalPrice, 150.5);
        expect(entity.userLocationEntity.lat, 30.0);
        expect(entity.store.storeLat, 29.0);
        expect(entity.trackingLocation.lat, 30.5);
        expect(entity.items[0].name, 'Burger');
        expect(entity.shippingAddress, '90 St, New Cairo');
      },
    );

    test(
      'toEntity: Edge Case - should handle null/missing location and defaults',
      () {
        final firebaseModel = OrderTrackingFirebaseModel(
          updatedAt: null,
          status: 'pending',
          orderData: {
          },
          storeData: {},
          userData: {},
          orderItems: [],
          driverData: {},
          trackingLocation: {},
        );

        // Act
        final entity = firebaseModel.toEntity();

        // Assert
        expect(entity.id, '');
        expect(entity.userLocationEntity.lat, 0.0); // Default value
        expect(entity.store.storeLat, 28.0); // Default store lat
        expect(entity.trackingLocation.lat, 0.0); // Default tracking lat
        expect(entity.updatedAt, isNotNull);
      },
    );

    test(
      'toEntity: ShippingAddress - should cover all formatting branches',
      () {
        final modelWithStreet = OrderTrackingFirebaseModel(
          orderData: {
            'shippingAddress': {'street': 'Zayed'},
          },
          status: '',
          storeData: {},
          userData: {},
          orderItems: [],
          driverData: {},
          trackingLocation: {},
        );

        final modelWithCity = OrderTrackingFirebaseModel(
          orderData: {
            'shippingAddress': {'city': 'Giza'},
          },
          status: '',
          storeData: {},
          userData: {},
          orderItems: [],
          driverData: {},
          trackingLocation: {},
        );

        final modelWithString = OrderTrackingFirebaseModel(
          orderData: {'shippingAddress': 'Cairo, Egypt'},
          status: '',
          storeData: {},
          userData: {},
          orderItems: [],
          driverData: {},
          trackingLocation: {},
        );

        expect(modelWithStreet.toEntity().shippingAddress, 'Zayed');
        expect(modelWithCity.toEntity().shippingAddress, 'Giza');
        expect(modelWithString.toEntity().shippingAddress, 'Cairo, Egypt');
      },
    );

    test('toEntity: Items - should use default quantity and price', () {
      // Arrange
      final modelWithEmptyItem = OrderTrackingFirebaseModel(
        orderItems: [
          {'productTitle': 'Pizza'},
        ],
        orderData: {},
        storeData: {},
        userData: {},
        status: '',
        driverData: {},
        trackingLocation: {},
      );

      // Act
      final entity = modelWithEmptyItem.toEntity();

      // Assert
      expect(entity.items[0].quantity, 1);
      expect(entity.items[0].price, '0');
    });
  });
}
