import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/response/update_order_state_mapper.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';
import 'package:tracking_app/Features/order/domain/entities/response/update_order_response_entity.dart';

void main() {
  group('UpdateOrderStateMapper Test', () {
    test('toEntity should convert UpdateOrderResponse to UpdateOrderResponseEntity correctly', () {
      // Arrange
      final mockOrderModel = Order(id: "123", state: 'updated');

      final response = UpdateOrderResponse(
        message: 'Order updated successfully',
        orders: mockOrderModel,
      );

      // Act
      final entity = response.toEntity();

      // Assert
      expect(entity, isA<UpdateOrderResponseEntity>());
      expect(entity.message, response.message);

      expect(entity.order, isNotNull);
      expect(entity.order?.id, response.orders?.id);
    });

    test('toEntity should handle null orders gracefully', () {
      // Arrange
      final response = UpdateOrderResponse(
        message: 'Update failed',
        orders: null,
      );

      // Act
      final entity = response.toEntity();

      // Assert
      expect(entity.order, isNull);
      expect(entity.message, 'Update failed');
    });
  });
}