import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';

void main() {
  group('VehicleResponse JSON Tests', () {
    final tVehicleJson = {
      "_id": "65cad123abc",
      "type": "Truck",
      "image": "truck.png",
    };

    final tResponseJson = {
      "message": "Vehicle retrieved successfully",
      "vehicle": tVehicleJson,
    };

    test('fromJson should return valid VehicleResponse with nested Vehicle', () {
      // Act
      final result = VehicleResponse.fromJson(tResponseJson);

      // Assert
      expect(result.message, "Vehicle retrieved successfully");
      expect(result.vehicle, isA<Vehicle>());
      expect(result.vehicle?.id, "65cad123abc");
    });

    test('toJson should return proper Map with nested vehicle map', () {
      // Arrange
      final tVehicle = Vehicle(id: "65cad123abc", type: "Truck");
      final tResponse = VehicleResponse(
        message: "Success",
        vehicle: tVehicle,
      );

      // Act
      final result = tResponse.toJson();

      // Assert
      expect(result['message'], "Success");
      expect(result['vehicle'], isA<Map<String, dynamic>>());
      expect(result['vehicle']['_id'], "65cad123abc");
    });
  });
}