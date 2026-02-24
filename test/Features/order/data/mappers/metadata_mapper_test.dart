import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/metadata_mapper.dart';
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/metadata_entity.dart';

void main() {
  group('MetadataMapper Test', () {
    test('toEntity should convert Metadata DTO to MetadataEntity correctly', () {
      // Arrange
      final metadataDto = Metadata(
        currentPage: 1,
        totalItems: 50,
        totalPages: 5,
        limit: 10,
      );

      // Act
      final entity = metadataDto.toEntity();

      // Assert
      expect(entity, isA<MetadataEntity>());
      expect(entity.currentPage, metadataDto.currentPage);
      expect(entity.totalItems, metadataDto.totalItems);
      expect(entity.totalPages, metadataDto.totalPages);
      expect(entity.limit, metadataDto.limit);
    });

    test('toEntity should handle zero values correctly', () {
      // Arrange: حالة لو مفيش بيانات خالص
      final metadataDto = Metadata(
        currentPage: 0,
        totalItems: 0,
        totalPages: 0,
        limit: 0,
      );

      // Act
      final entity = metadataDto.toEntity();

      // Assert
      expect(entity.totalItems, 0);
      expect(entity.totalPages, 0);
    });
  });
}