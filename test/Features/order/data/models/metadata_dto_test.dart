import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';

void main() {
  group('Metadata JSON Tests', () {
    final tMetadataJson = {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 50,
      "limit": 10
    };

    final tMetadata = Metadata(
      currentPage: 1,
      totalPages: 5,
      totalItems: 50,
      limit: 10,
    );

    test('fromJson should return a valid Metadata object', () {
      // Act
      final result = Metadata.fromJson(tMetadataJson);

      // Assert
      expect(result, isA<Metadata>());
      expect(result.currentPage, tMetadata.currentPage);
      expect(result.totalPages, tMetadata.totalPages);
      expect(result.totalItems, tMetadata.totalItems);
      expect(result.limit, tMetadata.limit);
    });

    test('toJson should return a proper Map', () {
      // Act
      final result = tMetadata.toJson();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['currentPage'], tMetadataJson['currentPage']);
      expect(result['totalPages'], tMetadataJson['totalPages']);
      expect(result['totalItems'], tMetadataJson['totalItems']);
      expect(result['limit'], tMetadataJson['limit']);
    });

    test('should handle missing fields in JSON safely', () {
      // Arrange:
      final Map<String, dynamic> emptyJson = {};

      // Act
      final result = Metadata.fromJson(emptyJson);

      // Assert
      expect(result.currentPage, isNull);
      expect(result.totalPages, isNull);
    });
  });
}