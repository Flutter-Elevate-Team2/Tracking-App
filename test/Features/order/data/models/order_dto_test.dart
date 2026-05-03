import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/order_item_dto.dart';
import 'package:tracking_app/Features/order/data/models/user_dto.dart';

void main() {
  group('Order DTO JSON Tests', () {
    final tUserJson = {
      "_id": "u_123",
      "firstName": "Ahmed",
    };

    final tOrderItemsJson = [
      {
        "_id": "item_1",
        "price": 100,
        "quantity": 2
      }
    ];

    final tOrderJson = {
      "_id": "ord_001",
      "user": tUserJson,
      "orderItems": tOrderItemsJson,
      "totalPrice": 200,
      "paymentType": "cash",
      "isPaid": true,
      "isDelivered": false,
      "state": "pending",
      "createdAt": "2026-02-24T10:00:00Z",
      "updatedAt": "2026-02-24T11:00:00Z",
      "orderNumber": "ORD-12345",
      "__v": 0
    };

    final tUserDto = User.fromJson(tUserJson);
    final tOrderItemsDto = [OrderItems.fromJson(tOrderItemsJson[0])];

    final tOrder = Order(
      id: "ord_001",
      user: tUserDto,
      orderItems: tOrderItemsDto,
      totalPrice: 200,
      paymentType: "cash",
      isPaid: true,
      isDelivered: false,
      state: "pending",
      createdAt: "2026-02-24T10:00:00Z",
      updatedAt: "2026-02-24T11:00:00Z",
      orderNumber: "ORD-12345",
      V: 0,
    );

    test('fromJson should return a valid Order object', () {
      // Act
      final result = Order.fromJson(tOrderJson);

      // Assert
      expect(result, isA<Order>());
      expect(result.id, tOrder.id);
      expect(result.totalPrice, tOrder.totalPrice);
      expect(result.isPaid, isTrue);
      expect(result.isDelivered, isFalse);
      expect(result.user?.id, tUserDto.id);
      expect(result.orderItems?.length, 1);
      expect(result.orderItems?[0].price, 100);
    });

    test('toJson should return a proper Map containing all fields', () {
      // Act
      final result = tOrder.toJson();

      // Assert
      expect(result['_id'], tOrderJson['_id']);
      expect(result['totalPrice'], tOrderJson['totalPrice']);
      expect(result['isPaid'], true);
      expect(result['orderNumber'], tOrderJson['orderNumber']);

      final userData = result['user'];
      if (userData is Map) {
        expect(userData['_id'], tUserJson['_id']);
      } else {
        expect(userData.id, tUserDto.id);
      }

      final itemsList = result['orderItems'] as List?;
      expect(itemsList, isNotNull);
      expect(itemsList?.length, 1);

      final firstItem = itemsList?[0];
      if (firstItem is Map) {
        expect(firstItem['_id'], tOrderItemsJson[0]['_id']);
      } else {
        expect(firstItem.id, tOrderItemsDto[0].id);
      }
    });

    test('should handle null fields in Order gracefully', () {
      // Arrange
      final emptyOrder = Order(id: "empty_1");

      // Act
      final json = emptyOrder.toJson();

      // Assert
      expect(json['user'], isNull);
      expect(json['orderItems'], isNull);
      expect(json['totalPrice'], isNull);
    });
  });
}