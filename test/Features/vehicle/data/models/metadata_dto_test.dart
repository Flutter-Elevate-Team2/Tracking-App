import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/vehicle/data/models/metadata_dto.dart';

void main() {
  group('Metadata JSON Tests', () {
    final tMetadataJson = {
      "currentPage": 1,
      "totalPages": 5,
      "limit": 10,
      "totalItems": 50,
    };

    final tMetadata = Metadata(
      currentPage: 1,
      totalPages: 5,
      limit: 10,
      totalItems: 50,
    );

    test('fromJson should return a valid Metadata object', () {
      final result = Metadata.fromJson(tMetadataJson);

      expect(result.currentPage, tMetadata.currentPage);
      expect(result.totalItems, tMetadata.totalItems);
    });

    test('toJson should return a Map containing the proper data', () {
      final result = tMetadata.toJson();

      expect(result['currentPage'], tMetadataJson['currentPage']);
      expect(result['totalItems'], tMetadataJson['totalItems']);
    });
  });
}