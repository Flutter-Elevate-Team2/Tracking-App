import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/edit_vehicle_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'edit_vehicle_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])
void main() {
  late EditVehicleUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<DriverEntity>>(
      ErrorResponse(errorMessage: 'dummy'),
    );
    mockRepo = MockProfileRepoContract();
    useCase = EditVehicleUseCase(mockRepo);
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
    vehicleType: 'Bike',
    vehicleNumber: '54321',
    vehicleLicense: 'ABC',
    nid: '123',
    nidImg: '',
  );

  test('should call editDriverProfile on the repository', () async {
    // arrange
    when(
      mockRepo.editDriverProfile(
        vehicleType: anyNamed('vehicleType'),
        vehicleNumber: anyNamed('vehicleNumber'),
        vehicleLicense: anyNamed('vehicleLicense'),
      ),
    ).thenAnswer((_) async => SuccessResponse(data: driver));

    // act
    final result = await useCase.call(
      vehicleType: 'Bike',
      vehicleNumber: '54321',
      vehicleLicense: null,
    );

    // assert
    expect(result, isA<SuccessResponse<DriverEntity>>());
    expect((result as SuccessResponse).data, driver);
    verify(
      mockRepo.editDriverProfile(
        vehicleType: 'Bike',
        vehicleNumber: '54321',
        vehicleLicense: null,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
