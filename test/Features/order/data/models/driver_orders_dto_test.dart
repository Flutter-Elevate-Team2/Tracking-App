import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/driver_orders_dto.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/store_dto.dart';

void main() {
  group('DriverOrders JSON Tests', () {
    final tOrderJson = {
      "_id": "order_123",
      "totalPrice": 500.0,
    };

    final tStoreJson = {
      "name": "Tech Store",
      "address": "Cairo, Egypt",
    };

    final tDriverOrdersJson = {
      "_id": "do_999",
      "driver": "driver_abc",
      "order": tOrderJson,
      "__v": 0,
      "createdAt": "2026-02-24T10:00:00Z",
      "updatedAt": "2026-02-24T12:00:00Z",
      "store": tStoreJson,
    };

    final tOrderDto = Order.fromJson(tOrderJson);
    final tStoreDto = Store.fromJson(tStoreJson);

    final tDriverOrders = DriverOrders(
      id: "do_999",
      driver: "driver_abc",
      order: tOrderDto,
      V: 0,
      createdAt: "2026-02-24T10:00:00Z",
      updatedAt: "2026-02-24T12:00:00Z",
      store: tStoreDto,
    );

    test('fromJson should return a valid DriverOrders object', () {
      // Act
      final result = DriverOrders.fromJson(tDriverOrdersJson);

      // Assert
      expect(result, isA<DriverOrders>());
      expect(result.id, tDriverOrders.id);
      expect(result.driver, tDriverOrders.driver);
      expect(result.V, tDriverOrders.V);
      expect(result.order?.id, tOrderDto.id);
      expect(result.store?.name, tStoreDto.name);
    });

    test('toJson should return a proper Map containing all fields', () {
      // Act
      final result = tDriverOrders.toJson();

      // Assert
      expect(result['_id'], tDriverOrdersJson['_id']);
      expect(result['driver'], tDriverOrdersJson['driver']);
      expect(result['__v'], tDriverOrdersJson['__v']);
      expect(result['createdAt'], tDriverOrdersJson['createdAt']);

      final orderData = result['order'];
      if (orderData is Map) {
        expect(orderData['_id'], tOrderJson['_id']);
      } else {
        expect(orderData.id, tOrderDto.id);
      }

      final storeData = result['store'];
      if (storeData is Map) {
        expect(storeData['name'], tStoreJson['name']);
      } else {
        expect(storeData.name, tStoreDto.name);
      }
    });

    test('should handle null nested objects safely', () {
      // Arrange
      final driverOrder = DriverOrders(id: "null_test", order: null, store: null);

      // Act
      final json = driverOrder.toJson();

      // Assert
      expect(json['order'], isNull);
      expect(json['store'], isNull);
    });
  });
}