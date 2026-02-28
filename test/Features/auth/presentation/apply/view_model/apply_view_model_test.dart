import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/Features/auth/domain/use_cases/apply_use_cases/apply_use_case.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_events.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_states.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'apply_view_model_test.mocks.dart';

@GenerateMocks([ApplyUseCase])
void main() {
  late ApplyViewModel viewModel;
  late MockApplyUseCase mockApplyUseCase;

  setUp(() {
    provideDummy<BaseResponse<ApplyEntity>>(
      SuccessResponse(
        data: ApplyEntity(token: "dummy", message: "success"),
      ),
    );

    mockApplyUseCase = MockApplyUseCase();
    viewModel = ApplyViewModel(mockApplyUseCase);
  });

  tearDown(() => viewModel.close());

  group('ApplyViewModel (Standard Tests)', () {
    final tEvent = OnApplyClickEvent(
      applyRequest: ApplyRequest(
        country: "country",
        firstName: "firstName",
        lastName: "lastName",
        vehicleType: "vehicleType",
        vehicleNumber: "vehicleNumber",
        nid: "nid",
        email: "email",
        password: "password",
        rePassword: "rePassword",
        gender: "gender",
        phone: "phone",
        vehicleLicense: File("vehicleLicense"),
        nidImg: File("vehicleLicense"),
      ),
    );

    test('Apply emits [Loading, Success] when usecase succeeds', () async {
      // ARRANGE
      final tEntity = ApplyEntity(token: "token", message: "success");
      when(
        mockApplyUseCase.call(any),
      ).thenAnswer((_) async => SuccessResponse(data: tEntity));

      // ASSERT
      final expectedStates = [
        // 1. Loading
        predicate<ApplyStates>((s) => s.applyState?.isLoading == true),
        // 2. Success
        predicate<ApplyStates>(
          (s) =>
              s.applyState?.isLoading == false && s.applyState?.data == tEntity,
        ),
      ];

      expectLater(viewModel.stream, emitsInOrder(expectedStates));

      // ACT
      viewModel.doIntent(tEvent);
    });

    test('Apply emits [Loading, Error] when usecase fails', () async {
      // ARRANGE
      when(
        mockApplyUseCase.call(any),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: "Error msg"));

      // ASSERT
      final expectedStates = [
        // 1. Loading
        predicate<ApplyStates>((s) => s.applyState?.isLoading == true),
        // 2. Error
        predicate<ApplyStates>(
          (s) =>
              s.applyState?.isLoading == false &&
              s.applyState?.errorMessage == "Error msg",
        ),
      ];

      expectLater(viewModel.stream, emitsInOrder(expectedStates));

      // ACT
      viewModel.doIntent(tEvent);
    });
  });
}
