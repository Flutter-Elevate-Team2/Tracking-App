import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/order_item_mapper.dart';
import 'package:tracking_app/Features/order/data/models/order_item_dto.dart';
import 'package:tracking_app/Features/order/data/models/product_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/orders_item_entity.dart';

void main() {
  group('OrderItemMapper Test', () {
    test('toEntity should convert OrderItems DTO to OrdersItemEntity correctly', () {
      // Arrange
      final mockProductModel = Product(id: 'prod_001', title: 'Coffee Bean');

      final orderItemDto = OrderItems(
        id: 'item_999',
        product: mockProductModel,
        price: 150,
        quantity: 2,
      );

      // Act
      final entity = orderItemDto.toEntity();

      // Assert
      expect(entity, isA<OrdersItemEntity>());
      expect(entity.id, orderItemDto.id);
      expect(entity.price, orderItemDto.price);
      expect(entity.quantity, orderItemDto.quantity);

      expect(entity.product, isNotNull);
      expect(entity.product?.id, orderItemDto.product?.id);
    });

    test('toEntity should handle null product correctly', () {
      // Arrange
      final orderItemDto = OrderItems(
        id: 'item_000',
        product: null,
        price: 0,
        quantity: 0,
      );

      // Act
      final entity = orderItemDto.toEntity();

      // Assert
      expect(entity.product, isNull);
      expect(entity.price, 0.0);
    });
  });
}