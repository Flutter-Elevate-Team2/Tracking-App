import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/product_mapper.dart';
import 'package:tracking_app/Features/order/data/models/product_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/product_entity.dart';

void main() {
  group('ProductMapper Test', () {
    test('toEntity should map Product DTO to ProductEntity with all fields correctly', () {
      // Arrange
      final productDto = Product(
        id: 'p_101',
        title: 'Red Rose Bouquet',
        slug: 'red-rose-bouquet',
        description: 'A beautiful bouquet of red roses',
        price: 500,
        priceAfterDiscount: 450,
        quantity: 15,
        sold: 100,
        imgCover: 'cover.jpg',
        images: ['img1.jpg', 'img2.jpg'],
        category: 'Flowers',
        occasion: 'Birthday',
        rateAvg: 4,
        rateCount: 25,
        isSuperAdmin: true,
        V: 2,
        createdAt: '2024-01-01',
        updatedAt: '2024-02-01',
      );

      //Act
      final entity = productDto.toEntity();

      // Assert
      expect(entity, isA<ProductEntity>());
      expect(entity.id, productDto.id);
      expect(entity.title, productDto.title);
      expect(entity.price, productDto.price);
      expect(entity.priceAfterDiscount, productDto.priceAfterDiscount);
      expect(entity.images, productDto.images);
      expect(entity.isSuperAdmin, isTrue);
      expect(entity.rateAvg, 4);
      expect(entity.V, 2);
    });

    test('toEntity should handle optional or empty fields', () {
      // Arrange
      final productDto = Product(
        id: 'p_empty',
        title: 'Minimal Product',
        images: [],
      );

      // Act
      final entity = productDto.toEntity();

      // Assert
      expect(entity.title, 'Minimal Product');
      expect(entity.images, isEmpty);
      expect(entity.description, isNull);
    });
  });
}