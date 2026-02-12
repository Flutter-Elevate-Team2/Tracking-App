import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/data/mapper/driver_mapper.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/driver.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/edit_profile_response.dart';

void main() {
  group('DriverMapper', () {
    test('toEntity maps all driver fields correctly', () {
      final response = EditProfileResponse(
        message: 'Success',
        driver: Driver(
          id: '123',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@test.com',
          phone: '+201234567890',
          photo: 'https://example.com/photo.jpg',
          role: 'driver',
          gender: 'male',
        ),
      );

      final entity = response.toEntity();

      expect(entity.id, '123');
      expect(entity.firstName, 'John');
      expect(entity.lastName, 'Doe');
      expect(entity.email, 'john@test.com');
      expect(entity.phone, '+201234567890');
      expect(entity.photoUrl, 'https://example.com/photo.jpg');
      expect(entity.role, 'driver');
      expect(entity.gender, 'male');
    });

    test('toEntity maps null driver to empty string defaults', () {
      final response = EditProfileResponse(message: 'Success', driver: null);

      final entity = response.toEntity();

      expect(entity.id, '');
      expect(entity.firstName, '');
      expect(entity.lastName, '');
      expect(entity.email, '');
      expect(entity.phone, '');
      expect(entity.photoUrl, '');
      expect(entity.role, 'driver');
      expect(entity.gender, '');
    });

    test('toEntity maps null driver fields to empty strings', () {
      final response = EditProfileResponse(
        message: 'Success',
        driver: Driver(),
      );

      final entity = response.toEntity();

      expect(entity.id, '');
      expect(entity.firstName, '');
      expect(entity.lastName, '');
      expect(entity.email, '');
      expect(entity.phone, '');
      expect(entity.photoUrl, '');
      expect(entity.role, 'driver');
      expect(entity.gender, '');
    });

    test('toEntity defaults role to driver when null', () {
      final response = EditProfileResponse(
        driver: Driver(
          id: '1',
          firstName: 'A',
          lastName: 'B',
          email: 'a@b.com',
          phone: '123',
          photo: 'url',
          role: null,
          gender: 'male',
        ),
      );

      final entity = response.toEntity();

      expect(entity.role, 'driver');
    });

    test('toEntity preserves non-default role', () {
      final response = EditProfileResponse(
        driver: Driver(
          id: '1',
          firstName: 'A',
          lastName: 'B',
          email: 'a@b.com',
          phone: '123',
          photo: 'url',
          role: 'admin',
          gender: 'female',
        ),
      );

      final entity = response.toEntity();

      expect(entity.role, 'admin');
      expect(entity.gender, 'female');
    });
  });
}
