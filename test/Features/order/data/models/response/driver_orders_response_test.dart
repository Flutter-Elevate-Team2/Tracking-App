import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/driver_orders_dto.dart';
import 'package:tracking_app/Features/order/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/order/data/models/response/driver_orders_response.dart';

void main() {
  group('DriverOrdersResponse JSON Tests', () {
    final tMetadataJson = {
      "currentPage": 1,
      "totalItems": 20,
      "totalPages": 2,
      "limit": 10
    };

    final tOrdersJson = [
      {
        "_id": "order_001",
        "driver": "driver_1",
        "createdAt": "2026-02-24T00:00:00Z"
      },
      {
        "_id": "order_002",
        "driver": "driver_1",
        "createdAt": "2026-02-24T01:00:00Z"
      }
    ];

    final tResponseJson = {
      "message": "success",
      "metadata": tMetadataJson,
      "orders": tOrdersJson,
    };

    final tMetadataDto = Metadata.fromJson(tMetadataJson);
    final tOrdersDto = (tOrdersJson)
        .map((e) => DriverOrders.fromJson(e))
        .toList();

    final tDriverOrdersResponse = DriverOrdersResponse(
      message: "success",
      metadata: tMetadataDto,
      orders: tOrdersDto,
    );

    test('fromJson should return a valid DriverOrdersResponse object', () {
      // Act
      final result = DriverOrdersResponse.fromJson(tResponseJson);

      // Assert
      expect(result, isA<DriverOrdersResponse>());
      expect(result.message, tDriverOrdersResponse.message);
      expect(result.metadata?.currentPage, tMetadataDto.currentPage);
      expect(result.orders?.length, tOrdersDto.length);
      expect(result.orders?[0].id, tOrdersDto[0].id);
    });

    test('toJson should return proper Map', () {
      // Arrange
      final tMetadataDto = Metadata.fromJson(tMetadataJson);
      final tResponse = DriverOrdersResponse(
        message: "success",
        metadata: tMetadataDto,
        orders: [],
      );

      // Act
      final result = tResponse.toJson();

      // Assert
      expect(result['message'], "success");

      if (result['metadata'] is Map) {
        expect(result['metadata']['currentPage'], tMetadataJson['currentPage']);
      } else {
        expect(result['metadata'].currentPage, tMetadataJson['currentPage']);
      }
    });
    test('should handle null fields in DriverOrdersResponse gracefully', () {
      // Arrange
      final emptyResponse = DriverOrdersResponse();

      // Act
      final json = emptyResponse.toJson();

      // Assert
      expect(json['message'], isNull);
      expect(json['metadata'], isNull);
      expect(json['orders'], isNull);
    });
  });
}