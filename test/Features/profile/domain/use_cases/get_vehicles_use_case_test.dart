import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_vehicles_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'get_vehicles_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])
void main() {
  late GetVehiclesUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<List<VehicleEntity>>>(
      ErrorResponse(errorMessage: 'dummy'),
    );
    mockRepo = MockProfileRepoContract();
    useCase = GetVehiclesUseCase(mockRepo);
  });

  test('should get vehicles from the repository', () async {
    final vehicles = [VehicleEntity(id: '1', type: 'Car', image: 'url')];

    when(
      mockRepo.getVehicles(),
    ).thenAnswer((_) async => SuccessResponse(data: vehicles));

    final result = await useCase.call();

    expect(result, isA<SuccessResponse<List<VehicleEntity>>>());
    expect((result as SuccessResponse).data, vehicles);
    verify(mockRepo.getVehicles());
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return error response when repository fails', () async {
    const errorMessage = 'Error fetching vehicles';

    when(
      mockRepo.getVehicles(),
    ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

    final result = await useCase.call();

    expect(result, isA<ErrorResponse>());
    expect((result as ErrorResponse).errorMessage, errorMessage);
    verify(mockRepo.getVehicles());
    verifyNoMoreInteractions(mockRepo);
  });
}
