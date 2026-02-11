import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/driver_dto.dart';

void main() {
  group('DriverDto JSON Tests', () {
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

    final tDriverDto = DriverDto(
      country: "Egypt",
      firstName: "Malak",
      lastName: "Hassan",
      vehicleType: "Car",
      vehicleNumber: "12345",
      vehicleLicense: "AB1234",
      nid: "987654321",
      nidImg: "nid_img.png",
      email: "malak@test.com",
      gender: "female",
      phone: "01012345678",
      photo: "photo.png",
      role: "driver",
      id: "id123",
      createdAt: "2026-02-09T00:00:00Z",
    );

    test('fromJson should return valid DriverDto object', () {
      final result = DriverDto.fromJson(tDriverJson);

      expect(result, isA<DriverDto>());
      expect(result.firstName, tDriverDto.firstName);
      expect(result.lastName, tDriverDto.lastName);
      expect(result.email, tDriverDto.email);
      expect(result.vehicleLicense, tDriverDto.vehicleLicense);
      expect(result.nid, tDriverDto.nid);
      expect(result.nidImg, tDriverDto.nidImg);
    });

    test('toJson should return proper Map', () {
      final result = tDriverDto.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['firstName'], tDriverJson['firstName']);
      expect(result['lastName'], tDriverJson['lastName']);
      expect(result['email'], tDriverJson['email']);
      expect(result['vehicleLicense'], tDriverJson['vehicleLicense']);
      expect(result['NID'], tDriverJson['NID']);
      expect(result['NIDImg'], tDriverJson['NIDImg']);
    });

    test('should handle null fields', () {
      final emptyDto = DriverDto();

      final json = emptyDto.toJson();
      expect(json['firstName'], null);
      expect(json['lastName'], null);
      expect(json['NID'], null);
      expect(json['NIDImg'], null);
    });
  });
}
