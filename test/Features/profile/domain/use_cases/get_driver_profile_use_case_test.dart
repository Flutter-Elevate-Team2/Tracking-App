import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'get_driver_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])
void main() {
  provideDummy<BaseResponse<DriverEntity>>(
    SuccessResponse(
      data: DriverEntity(
        id: '', firstName: '', lastName: '', email: '', phone: '',
        photo: '', role: '', gender: '', country: '', vehicleType: '',
        vehicleNumber: '', vehicleLicense: '', nid: '', nidImg: '',
      ),
    ),
  );

  late GetDriverProfileUseCase useCase;
  late MockProfileRepoContract mockRepo;

  final tDriverEntity = DriverEntity(
    id: '1',
    firstName: 'Test',
    lastName: 'Driver',
    email: 'test@driver.com',
    phone: '123456',
    photo: '',
    role: 'driver',
    gender: 'male',
    country: 'EG',
    vehicleType: 'Car',
    vehicleNumber: '123',
    vehicleLicense: '456',
    nid: '789',
    nidImg: '',
  );

  setUp(() {
    mockRepo = MockProfileRepoContract();
    useCase = GetDriverProfileUseCase(mockRepo);
  });

  group('GetDriverProfileUseCase Tests', () {
    test('call should return SuccessResponse from repository when successful', () async {
      // Arrange
      final successResponse = SuccessResponse<DriverEntity>(data: tDriverEntity);

      when(mockRepo.getDriverProfile())
          .thenAnswer((_) async => successResponse);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, successResponse);
      expect(result, isA<SuccessResponse<DriverEntity>>());
      verify(mockRepo.getDriverProfile()).called(1);
    });

    test('call should return ErrorResponse when repository fails', () async {
      // Arrange
      const errorMessage = 'Network Error';
      final errorResponse = ErrorResponse<DriverEntity>(errorMessage: errorMessage);

      when(mockRepo.getDriverProfile())
          .thenAnswer((_) async => errorResponse);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, errorResponse);
      expect(result, isA<ErrorResponse<DriverEntity>>());
      expect((result as ErrorResponse).errorMessage, errorMessage);
      verify(mockRepo.getDriverProfile()).called(1);
    });
  });
}
