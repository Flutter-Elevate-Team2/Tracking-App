import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/metadata_dto.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';

void main() {
  group('AllVehiclesResponse JSON Tests', () {
    final tVehicleJson = {
      "_id": "veh123",
      "type": "Car",
      "image": "car.png",
      "licenseNumber": "ABC123",
      "vehicleNumber": "12345"
    };
    final tVehicleDto = Vehicle.fromJson(tVehicleJson);

    final tMetadataJson = {
      "totalItems": 1,
      "currentPage": 1,
      "totalPages":1,
      "limit": 10,
    };
    final tMetadata = Metadata.fromJson(tMetadataJson);

    final tJson = {
      "message": "Success",
      "metadata": tMetadataJson,
      "vehicles": [tVehicleJson],
    };

    final tResponse = AllVehiclesResponse(
      message: "Success",
      metadata: tMetadata,
      vehicles: [tVehicleDto],
    );

    test('fromJson should return valid AllVehiclesResponse object', () {
      final result = AllVehiclesResponse.fromJson(tJson);

      expect(result, isA<AllVehiclesResponse>());
      expect(result.message, tResponse.message);
      expect(result.metadata?.totalItems, tMetadata.totalItems);
      expect(result.vehicles?.length, 1);
      expect(result.vehicles?.first.type, tVehicleDto.type);
      expect(result.vehicles?.first.image, tVehicleDto.image);
    });

    test('toJson should return proper Map including nested metadata and vehicles', () {
      final result = tResponse.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['message'], tJson['message']);

      final metadataMap = result['metadata'] as Map<String, dynamic>?;
      expect(metadataMap, isNotNull);
      expect(metadataMap?['totalItems'], tMetadataJson['totalItems']);
      expect(metadataMap?['currentPage'], tMetadataJson['currentPage']);
      expect(metadataMap?['totalPage'], tMetadataJson['totalPage']);
      expect(metadataMap?['limit'], tMetadataJson['limit']);

      final vehiclesList = result['vehicles'] as List<dynamic>?;
      expect(vehiclesList, isNotNull);
      expect(vehiclesList?.length, 1);

      final vehicleMap = vehiclesList?.first as Map<String, dynamic>;
      expect(vehicleMap['_id'], tVehicleJson['_id']);
      expect(vehicleMap['type'], tVehicleJson['type']);
      expect(vehicleMap['image'], tVehicleJson['image']);
    });

    test('should handle null fields safely', () {
      final emptyResponse = AllVehiclesResponse();

      final json = emptyResponse.toJson();
      expect(json['message'], null);
      expect(json['metadata'], null);
      expect(json['vehicles'], null);
    });
  });
}
