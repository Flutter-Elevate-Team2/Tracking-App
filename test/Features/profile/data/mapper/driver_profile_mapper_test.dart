import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/data/mapper/driver_profile_mapper.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';

void main() {
  group('DriverProfileMapper', () {
    test('toEntity should map DriverProfileResponse to DriverEntity', () {
      // arrange
      final response = DriverProfileResponse(
        message: 'Success',
        driver: DriverModel(
          id: '123',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          phone: '1234567890',
          photo: 'photo.jpg',
          role: 'driver',
          gender: 'Male',
          country: 'US',
          vehicleType: 'Car',
          vehicleNumber: 'ABC-123',
          vehicleLicense: 'license.jpg',
          nid: '987654321',
          nidImg: 'nid.jpg',
        ),
      );

      // act
      final entity = response.toEntity();

      // assert
      expect(entity, isA<DriverEntity>());
      expect(entity.id, '123');
      expect(entity.firstName, 'John');
      expect(entity.lastName, 'Doe');
      expect(entity.email, 'john@example.com');
      expect(entity.phone, '1234567890');
      expect(entity.photo, 'photo.jpg');
      expect(entity.role, 'driver');
      expect(entity.gender, 'Male');
      expect(entity.country, 'US');
      expect(entity.vehicleType, 'Car');
      expect(entity.vehicleNumber, 'ABC-123');
      expect(entity.vehicleLicense, 'license.jpg');
      expect(entity.nid, '987654321');
      expect(entity.nidImg, 'nid.jpg');
    });

    test('toEntity should handle null driver data gracefully', () {
      // arrange
      final response = DriverProfileResponse(message: 'Error', driver: null);

      // act
      final entity = response.toEntity();

      // assert
      expect(entity, isA<DriverEntity>());
      expect(entity.id, '');
      expect(entity.firstName, '');
      expect(entity.lastName, '');
      expect(entity.role, 'driver');
    });
  });
}
