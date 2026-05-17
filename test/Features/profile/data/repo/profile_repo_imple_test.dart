import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';
import 'package:tracking_app/Features/profile/data/models/logout_response.dart';
import 'package:tracking_app/Features/profile/data/models/upload_photo/upload_photo_response.dart';
import 'package:tracking_app/Features/profile/data/models/vehicles_response.dart';
import 'package:tracking_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:tracking_app/Features/profile/data/repo/profile_repo_imple.dart';
import 'package:tracking_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@GenerateMocks([ProfileRemoteDataSourceContract])
import 'profile_repo_imple_test.mocks.dart';

void main() {
  late ProfileRepoImple repo;
  late MockProfileRemoteDataSourceContract mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSourceContract();
    repo = ProfileRepoImple(mockRemoteDataSource);
  });

  // ---------------------------------------------------------------------------
  // editProfile
  // ---------------------------------------------------------------------------
  group('editProfile', () {
    final request = EditProfileRequest(
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@test.com',
      phone: '+201234567890',
    );

    final driverModel = DriverModel(
      id: '123',
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@test.com',
      phone: '+201234567890',
      photo: 'photo.jpg',
      role: 'driver',
      gender: 'female',
      country: 'Egypt',
      vehicleType: 'car',
      vehicleNumber: 'ABC123',
      vehicleLicense: 'license.jpg',
      nid: '12345',
      nidImg: 'nid.jpg',
    );

    final response = DriverProfileResponse(
      message: 'Profile updated',
      driver: driverModel,
    );

    test(
      'returns SuccessResponse<DriverEntity> when data source succeeds',
      () async {
        when(
          mockRemoteDataSource.editProfile(request),
        ).thenAnswer((_) async => response);

        final result = await repo.editProfile(request);

        expect(result, isA<SuccessResponse<DriverEntity>>());
        final data = (result as SuccessResponse<DriverEntity>).data;
        expect(data.firstName, 'Jane');
        expect(data.lastName, 'Doe');
        expect(data.email, 'jane@test.com');
        verify(mockRemoteDataSource.editProfile(request)).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.editProfile(request),
      ).thenThrow(Exception('Network error'));

      final result = await repo.editProfile(request);

      expect(result, isA<ErrorResponse<DriverEntity>>());
    });
  });

  // ---------------------------------------------------------------------------
  // changePassword
  // ---------------------------------------------------------------------------
  group('changePassword', () {
    final request = ChangePasswordRequest(
      password: 'oldPass',
      newPassword: 'newPass',
    );

    final response = ChangePasswordResponse(
      message: 'Password changed',
      token: 'new_token',
    );

    test(
      'returns SuccessResponse<ChangePasswordEntity> when succeeds',
      () async {
        when(
          mockRemoteDataSource.changePassword(request),
        ).thenAnswer((_) async => response);

        final result = await repo.changePassword(request);

        expect(result, isA<SuccessResponse<ChangePasswordEntity>>());
        final data = (result as SuccessResponse<ChangePasswordEntity>).data;
        expect(data.message, 'Password changed');
        expect(data.token, 'new_token');
        verify(mockRemoteDataSource.changePassword(request)).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.changePassword(request),
      ).thenThrow(Exception('Wrong password'));

      final result = await repo.changePassword(request);

      expect(result, isA<ErrorResponse<ChangePasswordEntity>>());
    });
  });

  // ---------------------------------------------------------------------------
  // uploadPhoto
  // ---------------------------------------------------------------------------
  group('uploadPhoto', () {
    final file = File('test_photo.jpg');
    final response = UploadPhotoResponse(message: 'Photo uploaded');

    test(
      'returns SuccessResponse<String> with message when succeeds',
      () async {
        when(
          mockRemoteDataSource.uploadPhoto(file),
        ).thenAnswer((_) async => response);

        final result = await repo.uploadPhoto(file);

        expect(result, isA<SuccessResponse<String>>());
        expect((result as SuccessResponse<String>).data, 'Photo uploaded');
        verify(mockRemoteDataSource.uploadPhoto(file)).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.uploadPhoto(file),
      ).thenThrow(Exception('Upload failed'));

      final result = await repo.uploadPhoto(file);

      expect(result, isA<ErrorResponse<String>>());
    });
  });

  // ---------------------------------------------------------------------------
  // getDriverProfile
  // ---------------------------------------------------------------------------
  group('getDriverProfile', () {
    final driverModel = DriverModel(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
      phone: '123',
      photo: '',
      role: 'driver',
      gender: 'male',
      country: 'Egypt',
      vehicleType: 'car',
      vehicleNumber: 'XYZ',
      vehicleLicense: 'lic',
      nid: '999',
      nidImg: '',
    );

    final response = DriverProfileResponse(
      message: 'Success',
      driver: driverModel,
    );

    test('returns SuccessResponse<DriverEntity> when succeeds', () async {
      when(
        mockRemoteDataSource.getDriverProfile(),
      ).thenAnswer((_) async => response);

      final result = await repo.getDriverProfile();

      expect(result, isA<SuccessResponse<DriverEntity>>());
      final data = (result as SuccessResponse<DriverEntity>).data;
      expect(data.id, '1');
      expect(data.firstName, 'John');
      verify(mockRemoteDataSource.getDriverProfile()).called(1);
    });

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.getDriverProfile(),
      ).thenThrow(Exception('Server error'));

      final result = await repo.getDriverProfile();

      expect(result, isA<ErrorResponse<DriverEntity>>());
    });
  });

  // ---------------------------------------------------------------------------
  // logout
  // ---------------------------------------------------------------------------
  group('logout', () {
    final response = LogoutResponse(message: 'Logged out');

    test(
      'returns SuccessResponse<String> with message when succeeds',
      () async {
        when(mockRemoteDataSource.logout()).thenAnswer((_) async => response);

        final result = await repo.logout();

        expect(result, isA<SuccessResponse<String>>());
        expect((result as SuccessResponse<String>).data, 'Logged out');
        verify(mockRemoteDataSource.logout()).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(mockRemoteDataSource.logout()).thenThrow(Exception('Logout failed'));

      final result = await repo.logout();

      expect(result, isA<ErrorResponse<String>>());
    });
  });

  // ---------------------------------------------------------------------------
  // getVehicles
  // ---------------------------------------------------------------------------
  group('getVehicles', () {
    final vehicleModels = [
      VehicleModel(id: 'v1', type: 'Car', image: 'car.png'),
      VehicleModel(id: 'v2', type: 'Bike', image: 'bike.png'),
    ];

    final response = VehiclesResponse(
      message: 'Success',
      vehicles: vehicleModels,
    );

    test(
      'returns SuccessResponse<List<VehicleEntity>> when succeeds',
      () async {
        when(
          mockRemoteDataSource.getVehicles(),
        ).thenAnswer((_) async => response);

        final result = await repo.getVehicles();

        expect(result, isA<SuccessResponse<List<VehicleEntity>>>());
        final data = (result as SuccessResponse<List<VehicleEntity>>).data;
        expect(data.length, 2);
        expect(data[0].type, 'Car');
        expect(data[1].type, 'Bike');
        verify(mockRemoteDataSource.getVehicles()).called(1);
      },
    );

    test('returns ErrorResponse when data source throws', () async {
      when(
        mockRemoteDataSource.getVehicles(),
      ).thenThrow(Exception('Fetch failed'));

      final result = await repo.getVehicles();

      expect(result, isA<ErrorResponse<List<VehicleEntity>>>());
    });
  });
}
