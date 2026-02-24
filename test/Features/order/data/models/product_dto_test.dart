import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/product_dto.dart';

void main() {
  group('Product DTO JSON Tests', () {
    final tProductJson = {
      "_id": "p_101",
      "title": "Red Roses",
      "slug": "red-roses",
      "description": "Beautiful red roses",
      "imgCover": "cover.jpg",
      "images": ["img1.jpg", "img2.jpg"],
      "price": 100,
      "priceAfterDiscount": 80,
      "quantity": 50,
      "category": "flowers",
      "occasion": "birthday",
      "createdAt": "2026-02-24T10:00:00Z",
      "updatedAt": "2026-02-24T12:00:00Z",
      "__v": 0,
      "sold": 10,
      "isSuperAdmin": false,
      "rateAvg": 4,
      "rateCount": 20
    };

    final tProduct = Product(
      id: "p_101",
      title: "Red Roses",
      slug: "red-roses",
      description: "Beautiful red roses",
      imgCover: "cover.jpg",
      images: ["img1.jpg", "img2.jpg"],
      price: 100,
      priceAfterDiscount: 80,
      quantity: 50,
      category: "flowers",
      occasion: "birthday",
      createdAt: "2026-02-24T10:00:00Z",
      updatedAt: "2026-02-24T12:00:00Z",
      V: 0,
      sold: 10,
      isSuperAdmin: false,
      rateAvg: 4,
      rateCount: 20,
    );

    test('fromJson should return a valid Product object with all fields', () {
      // Act
      final result = Product.fromJson(tProductJson);

      // Assert
      expect(result, isA<Product>());
      expect(result.id, tProduct.id);
      expect(result.title, tProduct.title);
      expect(result.images, isA<List<String>>());
      expect(result.images?.length, 2);
      expect(result.priceAfterDiscount, 80);
      expect(result.isSuperAdmin, isFalse);
    });

    test('toJson should return a proper Map containing all product fields', () {
      // Act
      final result = tProduct.toJson();

      // Assert
      expect(result['_id'], tProductJson['_id']);
      expect(result['title'], tProductJson['title']);
      expect(result['images'], tProductJson['images']);
      expect(result['priceAfterDiscount'], tProductJson['priceAfterDiscount']);
      expect(result['rateAvg'], tProductJson['rateAvg']);
      expect(result['isSuperAdmin'], tProductJson['isSuperAdmin']);
      expect(result['__v'], tProductJson['__v']);
    });

    test('should handle empty or null lists and fields gracefully', () {
      // Arrange
      final minimalProduct = Product(id: "min_1", title: "Minimal");

      // Act
      final json = minimalProduct.toJson();

      // Assert
      expect(json['_id'], "min_1");
      expect(json['images'], isNull);
      expect(json['price'], isNull);
      expect(json['isSuperAdmin'], isNull);
    });
  });
}