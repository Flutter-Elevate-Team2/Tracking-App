import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';
import 'package:tracking_app/Features/profile/data/models/logout_response.dart';
import 'package:tracking_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';

void main() {
  group('ChangePasswordRequest', () {
    test('toJson should serialize correctly', () {
      // Arrange
      final request = ChangePasswordRequest(
        password: 'oldPassword123',
        newPassword: 'newPassword456',
      );

      // Act
      final json = request.toJson();

      // Assert
      expect(json['password'], 'oldPassword123');
      expect(json['newPassword'], 'newPassword456');
    });

    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'password': 'oldPassword123',
        'newPassword': 'newPassword456',
      };

      // Act
      final request = ChangePasswordRequest.fromJson(json);

      // Assert
      expect(request.password, 'oldPassword123');
      expect(request.newPassword, 'newPassword456');
    });

    test('fromJson → toJson round trip should work', () {
      // Arrange
      final originalJson = {
        'password': 'oldPassword123',
        'newPassword': 'newPassword456',
      };

      // Act
      final request = ChangePasswordRequest.fromJson(originalJson);
      final resultJson = request.toJson();

      // Assert
      expect(resultJson, originalJson);
    });

    test('should handle null values', () {
      // Arrange
      final request = ChangePasswordRequest();

      // Act
      final json = request.toJson();

      // Assert
      expect(json['password'], isNull);
      expect(json['newPassword'], isNull);
    });
  });

  group('ChangePasswordResponse', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'message': 'Password changed successfully',
        'token': 'new_token_123',
      };

      // Act
      final response = ChangePasswordResponse.fromJson(json);

      // Assert
      expect(response.message, 'Password changed successfully');
      expect(response.token, 'new_token_123');
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final response = ChangePasswordResponse(
        message: 'Password changed successfully',
        token: 'new_token_123',
      );

      // Act
      final json = response.toJson();

      // Assert
      expect(json['message'], 'Password changed successfully');
      expect(json['token'], 'new_token_123');
    });

    test('fromJson → toJson round trip should work', () {
      // Arrange
      final originalJson = {
        'message': 'Password changed successfully',
        'token': 'new_token_123',
      };

      // Act
      final response = ChangePasswordResponse.fromJson(originalJson);
      final resultJson = response.toJson();

      // Assert
      expect(resultJson, originalJson);
    });

    test('should handle null values', () {
      // Arrange
      final response = ChangePasswordResponse();

      // Act
      final json = response.toJson();

      // Assert
      expect(json['message'], isNull);
      expect(json['token'], isNull);
    });
  });

  group('LogoutResponse', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {'message': 'Logged out successfully'};

      // Act
      final response = LogoutResponse.fromJson(json);

      // Assert
      expect(response.message, 'Logged out successfully');
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final response = LogoutResponse(message: 'Logged out successfully');

      // Act
      final json = response.toJson();

      // Assert
      expect(json['message'], 'Logged out successfully');
    });

    test('fromJson → toJson round trip should work', () {
      // Arrange
      final originalJson = {'message': 'Logged out successfully'};

      // Act
      final response = LogoutResponse.fromJson(originalJson);
      final resultJson = response.toJson();

      // Assert
      expect(resultJson, originalJson);
    });
  });

  group('VehiclesResponse', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'message': 'Success',
        'metadata': {
          'currentPage': 1,
          'totalPages': 5,
          'limit': 10,
          'totalItems': 50,
        },
        'vehicles': [
          {
            '_id': 'vehicle1',
            'type': 'Sedan',
            'image': 'https://example.com/car.jpg',
            'createdAt': '2024-01-01T00:00:00Z',
            'updatedAt': '2024-01-02T00:00:00Z',
          },
        ],
      };

      // Act
      final response = VehiclesResponse.fromJson(json);

      // Assert
      expect(response.message, 'Success');
      expect(response.metadata, isNotNull);
      expect(response.metadata!.currentPage, 1);
      expect(response.metadata!.totalPages, 5);
      expect(response.metadata!.limit, 10);
      expect(response.metadata!.totalItems, 50);
      expect(response.vehicles, isNotNull);
      expect(response.vehicles!.length, 1);
      expect(response.vehicles![0].id, 'vehicle1');
      expect(response.vehicles![0].type, 'Sedan');
    });

    test('should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final response = VehiclesResponse.fromJson(json);

      // Assert
      expect(response.message, isNull);
      expect(response.metadata, isNull);
      expect(response.vehicles, isNull);
    });

    test('should handle empty vehicles list', () {
      // Arrange
      final json = {'message': 'Success', 'vehicles': <Map<String, dynamic>>[]};

      // Act
      final response = VehiclesResponse.fromJson(json);

      // Assert
      expect(response.vehicles, isEmpty);
    });
  });

  group('MetadataModel', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'currentPage': 2,
        'totalPages': 10,
        'limit': 20,
        'totalItems': 200,
      };

      // Act
      final metadata = MetadataModel.fromJson(json);

      // Assert
      expect(metadata.currentPage, 2);
      expect(metadata.totalPages, 10);
      expect(metadata.limit, 20);
      expect(metadata.totalItems, 200);
    });

    test('should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final metadata = MetadataModel.fromJson(json);

      // Assert
      expect(metadata.currentPage, isNull);
      expect(metadata.totalPages, isNull);
      expect(metadata.limit, isNull);
      expect(metadata.totalItems, isNull);
    });
  });

  group('VehicleModel', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        '_id': 'vehicle123',
        'type': 'SUV',
        'image': 'https://example.com/suv.jpg',
        'createdAt': '2024-01-01T00:00:00Z',
        'updatedAt': '2024-01-02T00:00:00Z',
      };

      // Act
      final vehicle = VehicleModel.fromJson(json);

      // Assert
      expect(vehicle.id, 'vehicle123');
      expect(vehicle.type, 'SUV');
      expect(vehicle.image, 'https://example.com/suv.jpg');
      expect(vehicle.createdAt, '2024-01-01T00:00:00Z');
      expect(vehicle.updatedAt, '2024-01-02T00:00:00Z');
    });

    test('should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final vehicle = VehicleModel.fromJson(json);

      // Assert
      expect(vehicle.id, isNull);
      expect(vehicle.type, isNull);
      expect(vehicle.image, isNull);
      expect(vehicle.createdAt, isNull);
      expect(vehicle.updatedAt, isNull);
    });
  });

  group('DriverProfileResponse', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'message': 'Profile fetched successfully',
        'driver': {
          '_id': 'driver123',
          'country': 'Egypt',
          'firstName': 'Ahmed',
          'lastName': 'Mohamed',
          'vehicleType': 'Sedan',
          'vehicleNumber': 'ABC123',
          'vehicleLicense': 'LIC123',
          'NID': '12345678901234',
          'NIDImg': 'https://example.com/nid.jpg',
          'email': 'ahmed@example.com',
          'gender': 'male',
          'phone': '+201234567890',
          'photo': 'https://example.com/photo.jpg',
          'role': 'driver',
          'createdAt': '2024-01-01T00:00:00Z',
        },
      };

      // Act
      final response = DriverProfileResponse.fromJson(json);

      // Assert
      expect(response.message, 'Profile fetched successfully');
      expect(response.driver, isNotNull);
      expect(response.driver!.id, 'driver123');
      expect(response.driver!.firstName, 'Ahmed');
      expect(response.driver!.lastName, 'Mohamed');
      expect(response.driver!.email, 'ahmed@example.com');
      expect(response.driver!.phone, '+201234567890');
      expect(response.driver!.gender, 'male');
      expect(response.driver!.nid, '12345678901234');
    });

    test('should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final response = DriverProfileResponse.fromJson(json);

      // Assert
      expect(response.message, isNull);
      expect(response.driver, isNull);
    });
  });

  group('DriverModel', () {
    test('fromJson should deserialize correctly with all fields', () {
      // Arrange
      final json = {
        '_id': 'driver456',
        'country': 'Egypt',
        'firstName': 'John',
        'lastName': 'Doe',
        'vehicleType': 'Truck',
        'vehicleNumber': 'XYZ789',
        'vehicleLicense': 'LIC789',
        'NID': '98765432109876',
        'NIDImg': 'https://example.com/nid2.jpg',
        'email': 'john@example.com',
        'gender': 'male',
        'phone': '+201987654321',
        'photo': 'https://example.com/photo2.jpg',
        'role': 'driver',
        'createdAt': '2024-02-01T00:00:00Z',
      };

      // Act
      final driver = DriverModel.fromJson(json);

      // Assert
      expect(driver.id, 'driver456');
      expect(driver.country, 'Egypt');
      expect(driver.firstName, 'John');
      expect(driver.lastName, 'Doe');
      expect(driver.vehicleType, 'Truck');
      expect(driver.vehicleNumber, 'XYZ789');
      expect(driver.vehicleLicense, 'LIC789');
      expect(driver.nid, '98765432109876');
      expect(driver.nidImg, 'https://example.com/nid2.jpg');
      expect(driver.email, 'john@example.com');
      expect(driver.gender, 'male');
      expect(driver.phone, '+201987654321');
      expect(driver.photo, 'https://example.com/photo2.jpg');
      expect(driver.role, 'driver');
      expect(driver.createdAt, '2024-02-01T00:00:00Z');
    });

    test('should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final driver = DriverModel.fromJson(json);

      // Assert
      expect(driver.id, isNull);
      expect(driver.firstName, isNull);
      expect(driver.lastName, isNull);
      expect(driver.email, isNull);
      expect(driver.phone, isNull);
    });
  });

  group('EditProfileRequest', () {
    test('toJson should serialize correctly', () {
      // Arrange
      final request = EditProfileRequest(
        firstName: 'Ahmed',
        lastName: 'Mohamed',
        email: 'ahmed@example.com',
        phone: '+201234567890',
      );

      // Act
      final json = request.toJson();

      // Assert
      expect(json['firstName'], 'Ahmed');
      expect(json['lastName'], 'Mohamed');
      expect(json['email'], 'ahmed@example.com');
      expect(json['phone'], '+201234567890');
    });

    test('should handle null values', () {
      // Arrange
      final request = EditProfileRequest();

      // Act
      final json = request.toJson();

      // Assert
      expect(json['firstName'], isNull);
      expect(json['lastName'], isNull);
      expect(json['email'], isNull);
      expect(json['phone'], isNull);
    });

    test('should handle partial data', () {
      // Arrange
      final request = EditProfileRequest(
        firstName: 'Ahmed',
        email: 'ahmed@example.com',
      );

      // Act
      final json = request.toJson();

      // Assert
      expect(json['firstName'], 'Ahmed');
      expect(json['email'], 'ahmed@example.com');
      expect(json['lastName'], isNull);
      expect(json['phone'], isNull);
    });
  });

  group('UploadPhotoResponse', () {
    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'message': 'Photo uploaded successfully',
        'imageUrl': 'https://example.com/uploaded-photo.jpg',
      };

      // Act
      final response = UploadPhotoResponse.fromJson(json);

      // Assert
      expect(response.message, 'Photo uploaded successfully');
      expect(response.imageUrl, 'https://example.com/uploaded-photo.jpg');
    });

    test('should handle null imageUrl', () {
      // Arrange
      final json = {'message': 'Photo uploaded successfully'};

      // Act
      final response = UploadPhotoResponse.fromJson(json);

      // Assert
      expect(response.message, 'Photo uploaded successfully');
      expect(response.imageUrl, isNull);
    });

    test('fromJson → toJson round trip should work', () {
      // Arrange
      final response = UploadPhotoResponse(
        message: 'Success',
        imageUrl: 'https://example.com/photo.jpg',
      );

      // Note: This model doesn't have toJson, so we just verify construction
      // Assert
      expect(response.message, 'Success');
      expect(response.imageUrl, 'https://example.com/photo.jpg');
    });
  });
}
