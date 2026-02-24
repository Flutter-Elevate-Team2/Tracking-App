import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/data/mappers/apply_mapper/apply_mapper.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_response.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';

void main() {
  group('ApplyResponseMapper', () {
    test('toEntity should convert ApplyResponse to ApplyEntity correctly', () {
      // Arrange
      final applyResponse = ApplyResponse(message: 'Success', token: 'xyz789');

      // Act
      final entity = applyResponse.toEntity();

      // Assert
      expect(entity, isA<ApplyEntity>());
      expect(entity.message, applyResponse.message);
      expect(entity.token, applyResponse.token);
    });
  });
}
