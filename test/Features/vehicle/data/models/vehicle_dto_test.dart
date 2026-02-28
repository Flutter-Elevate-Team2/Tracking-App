import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';

void main() {
  group('Vehicle DTO Tests', () {
    final tVehicleJson = {
      "_id": "65cad123abc",
      "type": "Truck",
      "image": "truck_image.png",
      "createdAt": "2024-02-10T12:00:00Z",
      "updatedAt": "2024-02-11T12:00:00Z",
      "__v": 0
    };

    final tVehicleModel = Vehicle(
      id: "65cad123abc",
      type: "Truck",
      image: "truck_image.png",
      createdAt: "2024-02-10T12:00:00Z",
      updatedAt: "2024-02-11T12:00:00Z",
      V: 0,
    );

    test('fromJson should return a valid Vehicle object', () {
      // Act
      final result = Vehicle.fromJson(tVehicleJson);

      // Assert
      expect(result.id, tVehicleModel.id);
      expect(result.type, tVehicleModel.type);
      expect(result.V, tVehicleModel.V);
    });

    test('toJson should return a Map containing the proper data', () {
      // Act
      final result = tVehicleModel.toJson();

      // Assert
      expect(result['_id'], tVehicleJson['_id']);
      expect(result['type'], tVehicleJson['type']);
      expect(result['__v'], tVehicleJson['__v']);
    });

    test('should handle null values gracefully', () {
      // Act
      final result = Vehicle.fromJson({});

      // Assert
      expect(result.id, null);
      expect(result.type, null);
    });
  });
}