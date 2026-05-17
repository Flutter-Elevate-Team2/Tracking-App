import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/store_mapper.dart';
import 'package:tracking_app/Features/order/data/models/store_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/store_entity.dart';

void main() {
  group('StoreMapper Test', () {
    test('toEntity should convert Store DTO to StoreEntity correctly', () {
      // Arrange
      final storeDto = Store(
        name: 'Flower Shop',
        image: 'store_image.png',
        address: '123 Cairo Street',
        latLong: '30.0444,31.2357',
        phoneNumber: '01000000000',
      );

      // Act
      final entity = storeDto.toEntity();

      // Assert
      expect(entity, isA<StoreEntity>());
      expect(entity.name, storeDto.name);
      expect(entity.image, storeDto.image);
      expect(entity.address, storeDto.address);
      expect(entity.latLong, storeDto.latLong);
      expect(entity.phoneNumber, storeDto.phoneNumber);
    });

    test('toEntity should handle missing optional fields', () {
      // Arrange
      final storeDto = Store(
        name: 'Empty Store',
        address: 'No Address',
        latLong: null,
        phoneNumber: null,
      );

      // Act
      final entity = storeDto.toEntity();

      // Assert
      expect(entity.name, 'Empty Store');
      expect(entity.latLong, isNull);
      expect(entity.phoneNumber, isNull);
    });
  });
}