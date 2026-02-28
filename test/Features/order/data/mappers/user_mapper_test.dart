import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/mappers/user_mapper.dart';
import 'package:tracking_app/Features/order/data/models/user_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/user_entity.dart';

void main() {
  group('UserMapper Test', () {
    test('toEntity should convert User DTO to UserEntity correctly', () {
      // Arrange
      final userDto = User(
        id: 'user_123',
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@example.com',
        gender: 'male',
        passwordChangedAt: '2024-01-01',
        passwordResetCode: '2024-01-01',
        passwordResetExpires: '2024-01-02',
        resetCodeVerified: true,
        phone: '0123456789',
        photo: 'profile.jpg',
      );

      // Act
      final entity = userDto.toEntity();

      // Assert
      expect(entity, isA<UserEntity>());
      expect(entity.id, userDto.id);
      expect(entity.firstName, userDto.firstName);
      expect(entity.lastName, userDto.lastName);
      expect(entity.email, userDto.email);
      expect(entity.phone, userDto.phone);
      expect(entity.resetCodeVerified, isTrue);

      expect(entity.passwordResetCode, userDto.passwordResetCode);
      expect(entity.passwordChangedAt, userDto.passwordChangedAt);
    });

    test('toEntity should handle null values for optional user fields', () {
      // Arrange
      final userDto = User(
        id: 'user_456',
        firstName: 'John',
        email: 'john@doe.com',
      );

      // Act
      final entity = userDto.toEntity();

      // Assert
      expect(entity.lastName, isNull);
      expect(entity.photo, isNull);
      expect(entity.resetCodeVerified, isNull);
    });
  });
}