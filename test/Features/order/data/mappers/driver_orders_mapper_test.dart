import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/driver_orders_mapper.dart';
import 'package:tracking_app/Features/order/data/models/driver_orders_dto.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/store_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';

void main() {
  group('DriverOrdersMapper Test', () {
    test('toEntity should map DriverOrders to DriverOrdersEntity with all nested objects', () {
      // Arrange
      final mockOrder = Order(id: 'ord_123', totalPrice: 500);
      final mockStore = Store( name: 'Super Market');

      final driverOrderDto = DriverOrders(
        id: 'do_789',
        driver: 'driver_id_001',
        order: mockOrder,
        V: 1,
        store: mockStore,
        createdAt: '2024-05-20T10:00:00Z',
        updatedAt: '2024-05-20T11:00:00Z',
      );

      // Act
      final entity = driverOrderDto.toEntity();

      // Assert
      expect(entity, isA<DriverOrdersEntity>());
      expect(entity.id, driverOrderDto.id);
      expect(entity.driver, driverOrderDto.driver);
      expect(entity.V, driverOrderDto.V);
      expect(entity.createdAt, driverOrderDto.createdAt);
      expect(entity.updatedAt, driverOrderDto.updatedAt);

      expect(entity.order, isNotNull);
      expect(entity.order?.id, driverOrderDto.order?.id);

      expect(entity.store, isNotNull);
      expect(entity.store?.name, driverOrderDto.store?.name);
    });

    test('toEntity should handle null order and store', () {
      // Arrange
      final driverOrderDto = DriverOrders(
        id: 'do_000',
        driver: 'driver_none',
        order: null,
        V: 0,
        store: null,
        createdAt: '2024-05-20',
        updatedAt: '2024-05-20',
      );

      // Act
      final entity = driverOrderDto.toEntity();

      // Assert
      expect(entity.order, isNull);
      expect(entity.store, isNull);
    });
  });
}