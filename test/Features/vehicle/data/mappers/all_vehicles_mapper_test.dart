import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/data/mappers/all_vehicles_mapper.dart';

void main() {
  group('AllVehiclesMapper Tests', () {
    test('toEntity should transform AllVehiclesResponse to List<VehicleEntity>', () {
      // Arrange
      final tVehicleDto = Vehicle(
        id: "123",
        type: "Car",
        image: "car.png",
      );

      final tResponse = AllVehiclesResponse(
        vehicles: [tVehicleDto],
      );

      // Act
      final result = tResponse.toEntity();

      // Assert
      expect(result, isA<List<VehicleEntity>>());
      expect(result.length, 1);
      expect(result.first.id, tVehicleDto.id);
      expect(result.first.type, tVehicleDto.type);
    });

    test('should throw an error if vehicles list is null (based on your implementation)', () {
      final tResponse = AllVehiclesResponse(vehicles: null);

      expect(() => tResponse.toEntity(), throwsA(isA<TypeError>()));
    });
  });
}