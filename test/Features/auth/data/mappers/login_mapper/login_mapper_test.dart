import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/data/mappers/login_mapper/login_mapper.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';

void main() {
  group('LoginResponseMapper', () {
    test('toEntity should convert LoginResponse to LoginEntity correctly', () {
      // Arrange
      final loginResponse = LoginResponse(message: 'Success', token: 'abc123');

      // Act
      final entity = loginResponse.toEntity();

      // Assert
      expect(entity, isA<LoginEntity>());
      expect(entity.message, loginResponse.message);
      expect(entity.token, loginResponse.token);
    });
  });
}
