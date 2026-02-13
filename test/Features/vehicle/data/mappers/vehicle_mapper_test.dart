import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/vehicle/data/mappers/vehicle_mapper.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';

void main() {
  group('VehicleMapper Tests', () {
    test('toEntity should correctly map Vehicle DTO to VehicleEntity', () {
      // Arrange
      final tVehicleDto = Vehicle(
        id: "65cad123abc",
        type: "Truck",
        image: "truck.png",
        createdAt: "2024-02-10",
        updatedAt: "2024-02-11",
        V: 0,
      );

      // Act
      final result = tVehicleDto.toEntity();

      // Assert
      expect(result, isA<VehicleEntity>());
      expect(result.id, tVehicleDto.id);
      expect(result.type, tVehicleDto.type);
      expect(result.image, tVehicleDto.image);
      expect(result.createdAt, tVehicleDto.createdAt);
      expect(result.updatedAt, tVehicleDto.updatedAt);
    });

    test('should handle null fields during mapping', () {
      // Arrange
      final tVehicleDto = Vehicle(id: "123");

      // Act
      final result = tVehicleDto.toEntity();

      // Assert
      expect(result.id, "123");
      expect(result.type, null);
    });
  });
}