import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/order_mapper.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/order_item_dto.dart';
import 'package:tracking_app/Features/order/data/models/user_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';

void main() {
  group('OrderMapper Test', () {
    test('toEntity should convert Order DTO to OrderEntity with all nested objects and lists', () {
      // Arrange
      final mockUser = User(id: 'u_123', firstName: 'Ahmed');
      final mockItems = [
        OrderItems(id: 'i_1', price: 100, quantity: 2),
        OrderItems(id: 'i_2', price: 50, quantity: 1),
      ];

      final orderDto = Order(
        id: 'ord_555',
        user: mockUser,
        orderItems: mockItems,
        totalPrice: 250,
        paymentType: 'cash',
        isPaid: false,
        isDelivered: false,
        state: 'pending',
        createdAt: '2024-05-20',
        updatedAt: '2024-05-21',
        orderNumber: 'NUM-001',
      );

      // Act
      final entity = orderDto.toEntity();

      // Assert
      expect(entity, isA<OrderEntity>());
      expect(entity.id, orderDto.id);
      expect(entity.totalPrice, orderDto.totalPrice);
      expect(entity.isPaid, orderDto.isPaid);
      expect(entity.isDelivered, orderDto.isDelivered);
      expect(entity.orderNumber, orderDto.orderNumber);

      expect(entity.user, isNotNull);
      expect(entity.user?.id, orderDto.user?.id);

      expect(entity.orderItems?.length, orderDto.orderItems?.length);
      expect(entity.orderItems?[0].id, orderDto.orderItems?[0].id);
      expect(entity.orderItems?[1].price, orderDto.orderItems?[1].price);
    });

    test('toEntity should handle null values for user and items', () {
      // Arrange
      final orderDto = Order(
        id: 'ord_empty',
        user: null,
        orderItems: null,
        totalPrice: 0,
        isPaid: true,
      );

      // Act
      final entity = orderDto.toEntity();

      // Assert
      expect(entity.user, isNull);
      expect(entity.orderItems, isNull);
      expect(entity.isPaid, isTrue);
    });
  });
}