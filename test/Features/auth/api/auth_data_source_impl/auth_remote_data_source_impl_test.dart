import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:tracking_app/Features/auth/api/api_client/auth_api.dart';
import 'package:tracking_app/Features/auth/api/auth_data_source_impl/auth_remote_data_source_impl.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_response.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_response.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApi])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApi mockAuthApi;

  setUp(() {
    mockAuthApi = MockAuthApi();
    dataSource = AuthRemoteDataSourceImpl(mockAuthApi);
  });

  // ================= APPLY =================
  group('apply', () {
    final tRequest = ApplyRequest(
      country: 'EG',
      firstName: 'Malak',
      lastName: 'Hassan',
      vehicleType: 'Car',
      vehicleNumber: '1234',
      nid: '123456789',
      email: 'test@test.com',
      password: '123456',
      rePassword: '123456',
      gender: 'Female',
      phone: '01000000000',
      vehicleLicense: File('test_resources/dummy_license.txt'),
      nidImg: File('test_resources/dummy_nid.txt'),
    );

    final tResponse = ApplyResponse(message: 'Success', token: 'token');

    test('should return ApplyResponse when AuthApi.apply succeeds', () async {
      // arrange
      when(
        mockAuthApi.apply(
          tRequest.country,
          tRequest.firstName,
          tRequest.lastName,
          tRequest.vehicleType,
          tRequest.vehicleNumber,
          tRequest.nid,
          tRequest.email,
          tRequest.password,
          tRequest.rePassword,
          tRequest.gender,
          tRequest.phone,
          tRequest.vehicleLicense,
          tRequest.nidImg,
        ),
      ).thenAnswer((_) async => tResponse);

      // act
      final result = await dataSource.apply(tRequest);

      // assert
      expect(result, tResponse);
      verify(
        mockAuthApi.apply(
          tRequest.country,
          tRequest.firstName,
          tRequest.lastName,
          tRequest.vehicleType,
          tRequest.vehicleNumber,
          tRequest.nid,
          tRequest.email,
          tRequest.password,
          tRequest.rePassword,
          tRequest.gender,
          tRequest.phone,
          tRequest.vehicleLicense,
          tRequest.nidImg,
        ),
      ).called(1);
    });

    test('should throw Exception when AuthApi.apply fails', () async {
      // arrange
      when(
        mockAuthApi.apply(
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
        ),
      ).thenThrow(Exception('API Error'));

      // act & assert
      expect(() => dataSource.apply(tRequest), throwsException);
    });
  });

  // ================= LOGIN =================
  group('login', () {
    final tRequest = LoginRequest(email: 'test@test.com', password: '123456');

    final tResponse = LoginResponse(message: 'Success', token: 'token');

    test('should return LoginResponse when AuthApi.login succeeds', () async {
      // arrange
      when(mockAuthApi.login(tRequest)).thenAnswer((_) async => tResponse);

      // act
      final result = await dataSource.login(tRequest);

      // assert
      expect(result, tResponse);
      verify(mockAuthApi.login(tRequest)).called(1);
    });

    test('should throw Exception when AuthApi.login fails', () async {
      // arrange
      when(mockAuthApi.login(any)).thenThrow(Exception('Login Failed'));

      // act & assert
      expect(() => dataSource.login(tRequest), throwsException);
    });
  });
}
