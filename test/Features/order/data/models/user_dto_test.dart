import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/data/models/user_dto.dart';

void main() {
  group('User DTO JSON Tests', () {
    final tUserJson = {
      "_id": "u_777",
      "firstName": "Ziad",
      "lastName": "Hassan",
      "email": "ziad@example.com",
      "gender": "male",
      "phone": "01234567890",
      "photo": "avatar.png",
      "passwordChangedAt": "2026-02-20T10:00:00Z",
      "passwordResetCode": "123456",
      "passwordResetExpires": "2026-02-20T11:00:00Z",
      "resetCodeVerified": true
    };

    final tUser = User(
      id: "u_777",
      firstName: "Ziad",
      lastName: "Hassan",
      email: "ziad@example.com",
      gender: "male",
      phone: "01234567890",
      photo: "avatar.png",
      passwordChangedAt: "2026-02-20T10:00:00Z",
      passwordResetCode: "123456",
      passwordResetExpires: "2026-02-20T11:00:00Z",
      resetCodeVerified: true,
    );

    test('fromJson should return a valid User object with all fields', () {
      // Act
      final result = User.fromJson(tUserJson);

      // Assert
      expect(result, isA<User>());
      expect(result.id, tUser.id);
      expect(result.firstName, tUser.firstName);
      expect(result.email, tUser.email);
      expect(result.resetCodeVerified, isTrue);
      expect(result.passwordResetCode, "123456");
    });

    test('toJson should return a proper Map containing user data', () {
      // Act
      final result = tUser.toJson();

      // Assert
      expect(result['_id'], tUserJson['_id']);
      expect(result['firstName'], tUserJson['firstName']);
      expect(result['email'], tUserJson['email']);
      expect(result['resetCodeVerified'], true);
      expect(result['passwordResetCode'], tUserJson['passwordResetCode']);
    });

    test('should handle null fields in User gracefully', () {
      // Arrange:
      final minimalUser = User(
        id: "u_minimal",
        firstName: "Omar",
        email: "omar@test.com",
      );

      // Act
      final json = minimalUser.toJson();

      // Assert
      expect(json['_id'], "u_minimal");
      expect(json['resetCodeVerified'], isNull);
      expect(json['passwordResetCode'], isNull);
      expect(json['lastName'], isNull);
    });
  });
}