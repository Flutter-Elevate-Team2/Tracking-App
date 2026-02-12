import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/domain/use_cases/get_all_vehicles_use_case.dart';
import 'package:tracking_app/Features/vehicle/domain/vehicle_repo_contract/vehicle_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'get_all_vehicles_use_case_test.mocks.dart';

@GenerateMocks([VehicleRepoContract])
void main() {
  late GetAllVehiclesUseCase useCase;
  late MockVehicleRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<List<VehicleEntity>>>(
      SuccessResponse(
        data: [ VehicleEntity(id: "dummy")],
      ),
    );

    mockRepo = MockVehicleRepoContract();
    useCase = GetAllVehiclesUseCase(mockRepo);
  });

  final tVehiclesList = [
     VehicleEntity(id: "1", type: "Car"),
     VehicleEntity(id: "2", type: "Truck"),
  ];

  test(
    'should return SuccessResponse<List<VehicleEntity>> when repo succeeds',
        () async {
      // Arrange
      when(
        mockRepo.getAllVehicles(),
      ).thenAnswer((_) async => SuccessResponse(data: tVehiclesList));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<SuccessResponse<List<VehicleEntity>>>());
      expect((result as SuccessResponse).data, tVehiclesList);
      verify(mockRepo.getAllVehicles()).called(1);
    },
  );

  test(
    'should return ErrorResponse when repo fails to fetch vehicles',
        () async {
      // Arrange
      when(
        mockRepo.getAllVehicles(),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Server Error'));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<ErrorResponse>());
      verify(mockRepo.getAllVehicles()).called(1);
    },
  );
}