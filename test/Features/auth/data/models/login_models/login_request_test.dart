import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';

void main() {
  group('LoginRequest JSON Tests', () {
    final tJson = {
      "email": "test@test.com",
      "password": "123456",
    };

    final tLoginRequest = LoginRequest(
      email: "test@test.com",
      password: "123456",
    );

    test('fromJson should return valid LoginRequest object', () {
      final result = LoginRequest.fromJson(tJson);

      expect(result, isA<LoginRequest>());
      expect(result.email, tLoginRequest.email);
      expect(result.password, tLoginRequest.password);
    });

    test('toJson should return proper Map', () {
      final result = tLoginRequest.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['email'], tJson['email']);
      expect(result['password'], tJson['password']);
    });

    test('should handle null fields', () {
      final emptyRequest = LoginRequest();

      final json = emptyRequest.toJson();
      expect(json['email'], null);
      expect(json['password'], null);
    });
  });
}
