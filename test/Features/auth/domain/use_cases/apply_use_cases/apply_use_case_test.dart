import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/Features/auth/domain/use_cases/apply_use_cases/apply_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'apply_use_case_test.mocks.dart';

@GenerateMocks([AuthRepoContract])
void main() {
  late ApplyUseCase useCase;
  late MockAuthRepoContract mockRepo;

  setUp(() {
    provideDummy<BaseResponse<ApplyEntity>>(
      SuccessResponse(
        data: ApplyEntity(token: "dummy", message: "dummy"),
      ),
    );

    mockRepo = MockAuthRepoContract();
    useCase = ApplyUseCase(mockRepo);
  });

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
    gender: 'F',
    phone: '01000000000',
    vehicleLicense: File('test_resources/dummy_license.txt'),
    nidImg: File('test_resources/dummy_nid.txt'),
  );

  final tEntity = ApplyEntity(message: 'Success', token: 'abc123');

  test(
    'should return SuccessResponse<ApplyEntity> when repo succeeds',
    () async {
      when(
        mockRepo.apply(any),
      ).thenAnswer((_) async => SuccessResponse(data: tEntity));

      final result = await useCase(tRequest);

      expect(result, isA<SuccessResponse<ApplyEntity>>());
      verify(mockRepo.apply(tRequest)).called(1);
    },
  );

  test('should return ErrorResponse when repo throws Exception', () async {
    when(
      mockRepo.apply(any),
    ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Failed'));

    final result = await useCase(tRequest);

    expect(result, isA<ErrorResponse>());
    verify(mockRepo.apply(tRequest)).called(1);
  });
}
