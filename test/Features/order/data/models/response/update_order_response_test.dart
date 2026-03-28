import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/order_dto.dart';
import 'package:tracking_app/Features/order/data/models/response/update_order_response.dart';

void main() {
  group('UpdateOrderResponse JSON Tests', () {
    final tOrderJson = {
      "_id": "order_789",
      "totalPrice": 1500,
      "state": "delivered"
    };

    final tResponseJson = {
      "message": "Order updated successfully",
      "orders": tOrderJson,
    };

    final tOrderDto = Order.fromJson(tOrderJson);
    final tUpdateOrderResponse = UpdateOrderResponse(
      message: "Order updated successfully",
      orders: tOrderDto,
    );

    test('fromJson should return a valid UpdateOrderResponse object', () {
      // Act
      final result = UpdateOrderResponse.fromJson(tResponseJson);

      // Assert
      expect(result, isA<UpdateOrderResponse>());
      expect(result.message, tUpdateOrderResponse.message);
      expect(result.orders?.id, tOrderDto.id);
    });

    test('toJson should return proper Map containing order data', () {
      // Act
      final result = tUpdateOrderResponse.toJson();

      // Assert
      expect(result['message'], tResponseJson['message']);

      final ordersData = result['orders'];
      if (ordersData is Map) {
        expect(ordersData['_id'], tOrderJson['_id']);
      } else {
        expect(ordersData.id, tOrderDto.id);
      }
    });

    test('should handle null orders gracefully', () {
      // Arrange
      final response = UpdateOrderResponse(message: "Failed", orders: null);

      // Act
      final json = response.toJson();

      // Assert
      expect(json['message'], "Failed");
      expect(json['orders'], isNull);
    });
  });
}