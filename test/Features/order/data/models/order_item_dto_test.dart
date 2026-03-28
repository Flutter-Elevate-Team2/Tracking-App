import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/order_item_dto.dart';
import 'package:tracking_app/Features/order/data/models/product_dto.dart';

void main() {
  group('OrderItems DTO JSON Tests', () {
    final tProductJson = {
      "_id": "p_505",
      "title": "Fresh Flowers",
      "price": 150
    };

    final tOrderItemJson = {
      "_id": "item_888",
      "product": tProductJson,
      "price": 150,
      "quantity": 3
    };

    final tProductDto = Product.fromJson(tProductJson);
    final tOrderItem = OrderItems(
      id: "item_888",
      product: tProductDto,
      price: 150,
      quantity: 3,
    );

    test('fromJson should return a valid OrderItems object', () {
      // Act
      final result = OrderItems.fromJson(tOrderItemJson);

      // Assert
      expect(result, isA<OrderItems>());
      expect(result.id, tOrderItem.id);
      expect(result.price, tOrderItem.price);
      expect(result.quantity, tOrderItem.quantity);
      expect(result.product?.id, tProductDto.id);
    });

    test('toJson should return a proper Map containing nested product', () {
      // Act
      final result = tOrderItem.toJson();

      // Assert
      expect(result['_id'], tOrderItemJson['_id']);
      expect(result['price'], tOrderItemJson['price']);
      expect(result['quantity'], tOrderItemJson['quantity']);

      final productData = result['product'];
      if (productData is Map) {
        expect(productData['_id'], tProductJson['_id']);
        expect(productData['title'], tProductJson['title']);
      } else {
        expect(productData.id, tProductDto.id);
      }
    });

    test('should handle null product safely', () {
      // Arrange
      final itemWithNoProduct = OrderItems(id: "no_prod", product: null);

      // Act
      final json = itemWithNoProduct.toJson();

      // Assert
      expect(json['product'], isNull);
      expect(json['_id'], "no_prod");
    });
  });
}