import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/vehicle/data/mappers/vehicle_response_mapper.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';

void main() {
  group('VehicleResponseMapper Tests', () {
    test('toEntity should map VehicleResponse to VehicleEntity correctly', () {
      // Arrange
      final tVehicleDto = Vehicle(
        id: "abc-123",
        type: "Motorcycle",
      );

      final tResponse = VehicleResponse(
        message: "Success",
        vehicle: tVehicleDto,
      );

      // Act
      final result = tResponse.toEntity();

      // Assert
      expect(result, isA<VehicleEntity>());
      expect(result.id, tVehicleDto.id);
      expect(result.type, tVehicleDto.type);
    });

    test('should throw an error if vehicle object is null', () {
      final tResponse = VehicleResponse(message: "Error", vehicle: null);

      expect(() => tResponse.toEntity(), throwsA(isA<TypeError>()));
    });
  });
}