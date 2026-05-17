import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/data/models/order_tracking_firebase_model.dart';

void main() {
  group('OrderTrackingFirebaseModel', () {
    final tModel = OrderTrackingFirebaseModel(
      userData: {'userId': 'u1', 'deviceToken': 'token'},
      orderData: {'orderId': 'o1', 'totalPrice': 200},
      driverData: {'driverId': 'd1', 'driverName': 'John'},
      trackingLocation: {'lat': 30.0, 'long': 31.0},
      storeData: {'storeName': 'Store A'},
      orderItems: [
        {'productId': 'p1', 'quantity': 2},
      ],
      status: 'accepted',
      updatedAt: DateTime(2024, 1, 1),
    );

    test('constructor creates model with all fields', () {
      expect(tModel.userData['userId'], 'u1');
      expect(tModel.status, 'accepted');
      expect(tModel.orderItems.length, 1);
      expect(tModel.updatedAt, DateTime(2024, 1, 1));
    });

    test('toJson serializes all fields correctly', () {
      final json = tModel.toJson();
      expect(json['userData'], isA<Map>());
      expect(json['orderData'], isA<Map>());
      expect(json['driverData'], isA<Map>());
      expect(json['trackingLocation'], isA<Map>());
      expect(json['storeData'], isA<Map>());
      expect(json['orderItems'], isA<List>());
      expect(json['status'], 'accepted');
      expect(json['updatedAt'], isNotNull);
    });

    test('toJson with null updatedAt uses FieldValue.serverTimestamp()', () {
      final modelNoDate = OrderTrackingFirebaseModel(
        userData: {},
        orderData: {},
        driverData: {},
        trackingLocation: {},
        storeData: {},
        orderItems: [],
        status: 'pending',
        updatedAt: null,
      );
      final json = modelNoDate.toJson();
      expect(json['updatedAt'], isNotNull); // FieldValue.serverTimestamp()
    });

    group('fromJson', () {
      test('fromJson with all fields', () {
        final json = {
          'userData': {'userId': 'u1'},
          'orderData': {'orderId': 'o1'},
          'driverData': {'driverId': 'd1'},
          'trackingLocation': {'lat': 30.0, 'long': 31.0},
          'storeData': {'storeName': 'Store A'},
          'orderItems': [
            {'productId': 'p1'},
          ],
          'status': 'accepted',
          'updatedAt': '2024-01-01T00:00:00Z',
        };
        final model = OrderTrackingFirebaseModel.fromJson(json);
        expect(model.userData['userId'], 'u1');
        expect(model.status, 'accepted');
        expect(model.orderItems.length, 1);
        expect(model.updatedAt, isNotNull);
      });

      test('fromJson with null fields uses defaults', () {
        final model = OrderTrackingFirebaseModel.fromJson({});
        expect(model.userData, isEmpty);
        expect(model.orderData, isEmpty);
        expect(model.driverData, isEmpty);
        expect(model.trackingLocation, isEmpty);
        expect(model.storeData, isEmpty);
        expect(model.orderItems, isEmpty);
        expect(model.status, 'accepted');
        expect(model.updatedAt, isNull);
      });

      test('fromJson with null updatedAt', () {
        final json = {'updatedAt': null};
        final model = OrderTrackingFirebaseModel.fromJson(json);
        expect(model.updatedAt, isNull);
      });

      test('fromJson with String updatedAt parses correctly', () {
        final json = {'updatedAt': '2024-06-15T10:30:00Z'};
        final model = OrderTrackingFirebaseModel.fromJson(json);
        expect(model.updatedAt, isNotNull);
        expect(model.updatedAt?.year, 2024);
      });

      test('fromJson with invalid String updatedAt returns null', () {
        final json = {'updatedAt': 'not-a-date'};
        final model = OrderTrackingFirebaseModel.fromJson(json);
        expect(model.updatedAt, isNull);
      });
    });
  });
}
