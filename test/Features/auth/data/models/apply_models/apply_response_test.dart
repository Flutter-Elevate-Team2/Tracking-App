import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_response.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/driver_dto.dart';

void main() {
  group('ApplyResponse JSON Tests', () {
    final tDriverJson = {
      "country": "Egypt",
      "firstName": "Malak",
      "lastName": "Hassan",
      "vehicleType": "Car",
      "vehicleNumber": "12345",
      "vehicleLicense": "AB1234",
      "NID": "987654321",
      "NIDImg": "nid_img.png",
      "email": "malak@test.com",
      "gender": "female",
      "phone": "01012345678",
      "photo": "photo.png",
      "role": "driver",
      "_id": "id123",
      "createdAt": "2026-02-09T00:00:00Z",
    };

    final tJson = {
      "message": "Applied",
      "token": "abc123",
      "driver": tDriverJson,
    };

    final tDriverDto = DriverDto.fromJson(tDriverJson);
    final tApplyResponse = ApplyResponse(
      message: "Applied",
      token: "abc123",
      driver: tDriverDto,
    );

    test('fromJson should return valid ApplyResponse object', () {
      final result = ApplyResponse.fromJson(tJson);

      expect(result, isA<ApplyResponse>());
      expect(result.message, tApplyResponse.message);
      expect(result.token, tApplyResponse.token);
      expect(result.driver?.firstName, tDriverDto.firstName);
      expect(result.driver?.email, tDriverDto.email);
    });

    test('toJson should return proper Map including nested driver', () {
      final result = tApplyResponse.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['message'], tJson['message']);
      expect(result['token'], tJson['token']);

      // cast safely
      final driverMap = result['driver'] as Map<String, dynamic>?;

      expect(driverMap, isNotNull);
      expect(driverMap?['firstName'], tDriverJson['firstName']);
      expect(driverMap?['lastName'], tDriverJson['lastName']);
      expect(driverMap?['email'], tDriverJson['email']);
    });

    test('should handle null fields safely', () {
      final emptyResponse = ApplyResponse();

      final json = emptyResponse.toJson();
      expect(json['message'], null);
      expect(json['token'], null);
      expect(json['driver'], null);
    });
  });
}
