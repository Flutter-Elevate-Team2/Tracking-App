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
  late GetDriverProfileUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<DriverEntity>>(
      ErrorResponse(errorMessage: 'dummy'),
    );
    mockRepo = MockProfileRepoContract();
    useCase = GetDriverProfileUseCase(mockRepo);
  });

  final driver = DriverEntity(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '1234567890',
    photo: '',
    role: 'driver',
    gender: 'Male',
    country: 'US',
    vehicleType: 'Car',
    vehicleNumber: '12345',
    vehicleLicense: 'XYZ',
    nid: '123',
    nidImg: '',
  );

  test('should call getDriverProfile on the repository', () async {
    // arrange
    when(
      mockRepo.getDriverProfile(),
    ).thenAnswer((_) async => SuccessResponse(data: driver));

    // act
    final result = await useCase.call();

    // assert
    expect(result, isA<SuccessResponse<DriverEntity>>());
    expect((result as SuccessResponse).data, driver);
    verify(mockRepo.getDriverProfile()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
