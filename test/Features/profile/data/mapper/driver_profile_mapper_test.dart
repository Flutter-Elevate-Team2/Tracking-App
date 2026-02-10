import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/data/mapper/driver_profile_mapper.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';

void main() {
  group('DriverProfileMapper Tests', () {
    test('toEntity should map DriverProfileResponse to DriverEntity correctly with full data', () {
      // Arrange
      final driverModel = DriverModel(
        id: '123',
        firstName: 'Ahmed',
        lastName: 'Mohamed',
        email: 'ahmed@test.com',
        phone: '0100000000',
        photo: 'photo_url',
        role: 'driver',
        gender: 'male',
        country: 'Egypt',
        vehicleType: 'Car',
        vehicleNumber: 'ABC-123',
        vehicleLicense: 'LIC-999',
        nid: '123456789',
        nidImg: 'nid_img_url',
      );
      final response = DriverProfileResponse(message: 'Success', driver: driverModel);

      // Act
      final entity = response.toEntity();

      // Assert
      expect(entity, isA<DriverEntity>());
      expect(entity.id, '123');
      expect(entity.firstName, 'Ahmed');
      expect(entity.lastName, 'Mohamed');
      expect(entity.email, 'ahmed@test.com');
      expect(entity.role, 'driver');
      expect(entity.nid, '123456789');
    });

    test('toEntity should handle null values and return default empty strings', () {
      // Arrange
      final response = DriverProfileResponse(message: 'Success', driver: null);

      // Act
      final entity = response.toEntity();

      // Assert
      expect(entity, isA<DriverEntity>());
      expect(entity.id, '');
      expect(entity.firstName, '');
      expect(entity.lastName, '');
      expect(entity.email, '');
      expect(entity.role, 'driver');
      expect(entity.nid, '');
    });

    test('toEntity should handle partial null fields inside DriverModel', () {
      // Arrange
      final driverModel = DriverModel(
        id: '123',
        firstName: null,
        role: null,
      );
      final response = DriverProfileResponse(message: 'Success', driver: driverModel);

      // Act
      final entity = response.toEntity();

      // Assert
      expect(entity.id, '123');
      expect(entity.firstName, '');
      expect(entity.role, 'driver');
    });
  });
}
