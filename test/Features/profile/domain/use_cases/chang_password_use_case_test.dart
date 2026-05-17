import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/chang_password_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'chang_password_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])

void main() {
  late ChangPasswordUseCase useCase;
  late MockProfileRepoContract mockRepo;

  setUp(() {
    mockRepo = MockProfileRepoContract();
    useCase = ChangPasswordUseCase(mockRepo);

    provideDummy<BaseResponse<ChangePasswordEntity>>(
      ErrorResponse(errorMessage: ''),
    );
  });

  group('ChangPasswordUseCase', () {
    final request = ChangePasswordRequest(
      password: 'oldPass123',
      newPassword: 'newPass456',
    );

    test('returns SuccessResponse when repo succeeds', () async {
      const entity = ChangePasswordEntity(
        message: 'Password changed',
        token: 'new_token',
      );
      when(
        mockRepo.changePassword(request),
      ).thenAnswer((_) async => SuccessResponse(data: entity));

      final result = await useCase(request);

      expect(result, isA<SuccessResponse<ChangePasswordEntity>>());
      final success = result as SuccessResponse<ChangePasswordEntity>;
      expect(success.data.message, 'Password changed');
      expect(success.data.token, 'new_token');
      verify(mockRepo.changePassword(request)).called(1);
    });

    test('returns ErrorResponse when repo fails', () async {
      when(mockRepo.changePassword(request)).thenAnswer(
        (_) async => ErrorResponse(errorMessage: 'Invalid password'),
      );

      final result = await useCase(request);

      expect(result, isA<ErrorResponse<ChangePasswordEntity>>());
      expect((result as ErrorResponse).errorMessage, 'Invalid password');
      verify(mockRepo.changePassword(request)).called(1);
    });

    test('delegates call directly to repo', () async {
      when(mockRepo.changePassword(request)).thenAnswer(
        (_) async => SuccessResponse(
          data: const ChangePasswordEntity(message: 'ok', token: 't'),
        ),
      );

      await useCase(request);

      verify(mockRepo.changePassword(request)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
