import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@GenerateMocks([ProfileRepoContract])
import 'edit_profile_use_case_test.mocks.dart';

void main() {
  late EditProfileUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    mockRepo = MockProfileRepoContract();
    useCase = EditProfileUseCase(mockRepo);

    provideDummy<BaseResponse<DriverEntity>>(ErrorResponse(errorMessage: ''));
  });

  group('EditProfileUseCase', () {
    final request = EditProfileRequest(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
      phone: '+201234567890',
    );

    final driverEntity = DriverEntity(
      id: '123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
      phone: '+201234567890',
      photoUrl: 'url',
      role: 'driver',
      gender: 'male',
    );

    test('returns SuccessResponse when repo succeeds', () async {
      when(
        mockRepo.editProfile(request),
      ).thenAnswer((_) async => SuccessResponse(data: driverEntity));

      final result = await useCase(request);

      expect(result, isA<SuccessResponse<DriverEntity>>());
      final success = result as SuccessResponse<DriverEntity>;
      expect(success.data.firstName, 'John');
      expect(success.data.email, 'john@test.com');
      verify(mockRepo.editProfile(request)).called(1);
    });

    test('returns ErrorResponse when repo fails', () async {
      when(
        mockRepo.editProfile(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Server error'));

      final result = await useCase(request);

      expect(result, isA<ErrorResponse<DriverEntity>>());
      expect((result as ErrorResponse).errorMessage, 'Server error');
      verify(mockRepo.editProfile(request)).called(1);
    });

    test('delegates call directly to repo', () async {
      when(
        mockRepo.editProfile(request),
      ).thenAnswer((_) async => SuccessResponse(data: driverEntity));

      await useCase(request);

      verify(mockRepo.editProfile(request)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
