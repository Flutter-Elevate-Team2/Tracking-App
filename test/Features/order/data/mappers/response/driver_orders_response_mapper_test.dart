import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/response/driver_orders_response_mapper.dart';
import 'package:tracking_app/Features/order/data/models/driver_orders_dto.dart';
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';
import 'package:tracking_app/Features/order/domain/entities/response/driver_orders_response_entity.dart';

void main() {
  group('DriverOrdersResponseMapper Test', () {
    test('toEntity should correctly map DriverOrdersResponse to DriverOrdersResponseEntity', () {
      // Arrange
      final mockMetadata = Metadata(
        currentPage: 1,
        totalPages: 5,
        totalItems: 100,
        limit: 10
      );

      final mockOrders = [
        DriverOrders(id: "1"),
        DriverOrders(id: "2"),
      ];

      final response = DriverOrdersResponse(
        message: 'Fetched Successfully',
        metadata: mockMetadata,
        orders: mockOrders,
      );

      // Act
      final entity = response.toEntity();

      // Assert
      expect(entity, isA<DriverOrdersResponseEntity>());
      expect(entity.message, response.message);

      expect(entity.metadata!.currentPage, response.metadata?.currentPage);

      expect(entity.orders?.length, response.orders?.length);
      expect(entity.orders?[0].id, response.orders?[0].id);
    });

    test('toEntity should handle null orders gracefully', () {
      // Arrange
      final response = DriverOrdersResponse(
        message: 'No orders found',
        metadata: Metadata(currentPage: 0, totalPages: 0, totalItems: 0),
        orders: null,
      );

      // Act
      final entity = response.toEntity();

      // Assert
      expect(entity.orders, isNull);
    });
  });
}