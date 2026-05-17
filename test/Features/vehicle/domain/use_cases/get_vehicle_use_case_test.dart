import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/domain/use_cases/get_vehicle_use_case.dart';
import 'package:tracking_app/Features/vehicle/domain/vehicle_repo_contract/vehicle_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'get_vehicle_use_case_test.mocks.dart';

@GenerateMocks([VehicleRepoContract])
void main() {
  late GetVehicleUseCase useCase;
  late MockVehicleRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<VehicleEntity>>(
      SuccessResponse(
        data:  VehicleEntity(id: "dummy"),
      ),
    );

    mockRepo = MockVehicleRepoContract();
    useCase = GetVehicleUseCase(mockRepo);
  });

   final tVehicleId = "veh_123";
   final tVehicleEntity = VehicleEntity(
    id: tVehicleId,
    type: "Car",
    image: "car.png",
  );

  test(
    'should return SuccessResponse<VehicleEntity> when repo succeeds with valid ID',
        () async {
      // Arrange
      when(
        mockRepo.getVehicle(any),
      ).thenAnswer((_) async => SuccessResponse(data: tVehicleEntity));

      // Act
      final result = await useCase(tVehicleId);

      // Assert
      expect(result, isA<SuccessResponse<VehicleEntity>>());
      expect((result as SuccessResponse).data, tVehicleEntity);
      verify(mockRepo.getVehicle(tVehicleId)).called(1);
    },
  );

  test(
    'should return ErrorResponse when vehicle ID is not found',
        () async {
      // Arrange
      when(
        mockRepo.getVehicle(any),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Vehicle not found'));

      // Act
      final result = await useCase(tVehicleId);

      // Assert
      expect(result, isA<ErrorResponse>());
      verify(mockRepo.getVehicle(tVehicleId)).called(1);
    },
  );
}