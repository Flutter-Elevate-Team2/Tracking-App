import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

@GenerateMocks([EditProfileUseCase, UploadPhotoUseCase, SessionController])
import 'edit_profile_view_model_test.mocks.dart';

void main() {
  late EditProfileViewModel viewModel;
  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUploadPhotoUseCase mockUploadPhotoUseCase;
  late MockSessionController mockSessionController;
  final getIt = GetIt.instance;

  final driverEntity = DriverEntity(
    id: '123',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@test.com',
    phone: '+201234567890',
    photoUrl: 'https://example.com/photo.jpg',
    role: 'driver',
    gender: 'male',
  );

  setUp(() {
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUploadPhotoUseCase = MockUploadPhotoUseCase();
    mockSessionController = MockSessionController();

    provideDummy<BaseResponse<DriverEntity>>(ErrorResponse(errorMessage: ''));
    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: ''));

    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
    getIt.registerSingleton<SessionController>(mockSessionController);

    viewModel = EditProfileViewModel(
      editProfileUseCase: mockEditProfileUseCase,
      uploadPhotoUseCase: mockUploadPhotoUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
  });

  group('EditProfileViewModel - editProfile', () {
    final request = EditProfileRequest(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@test.com',
      phone: '+201234567890',
    );

    test(
      'emits loading then success state when edit profile succeeds',
      () async {
        when(
          mockEditProfileUseCase(request),
        ).thenAnswer((_) async => SuccessResponse(data: driverEntity));
        when(mockSessionController.saveUser(driverEntity)).thenReturn(null);

        final states = <EditProfileStates>[];
        final subscription = viewModel.stream.listen(states.add);

        viewModel.doIntent(EditProfileEvent(request));
        await Future.delayed(const Duration(milliseconds: 100));

        expect(states.length, 2);
        expect(states[0].editProfileState?.isLoading, true);
        expect(states[1].editProfileState?.isLoading, false);
        expect(states[1].editProfileState?.data, driverEntity);

        await subscription.cancel();
      },
    );

    test('emits loading then error state when edit profile fails', () async {
      when(
        mockEditProfileUseCase(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Server error'));

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(EditProfileEvent(request));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0].editProfileState?.isLoading, true);
      expect(states[1].editProfileState?.isLoading, false);
      expect(states[1].editProfileState?.errorMessage, 'Server error');

      await subscription.cancel();
    });

    test('saves user to session on success', () async {
      when(
        mockEditProfileUseCase(request),
      ).thenAnswer((_) async => SuccessResponse(data: driverEntity));
      when(mockSessionController.saveUser(driverEntity)).thenReturn(null);

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(EditProfileEvent(request));
      await Future.delayed(const Duration(milliseconds: 100));

      verify(mockSessionController.saveUser(driverEntity)).called(1);

      await subscription.cancel();
    });

    test('does not save user to session on error', () async {
      when(
        mockEditProfileUseCase(request),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'fail'));

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(EditProfileEvent(request));
      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(mockSessionController.saveUser(any));

      await subscription.cancel();
    });
  });

  group('EditProfileViewModel - uploadPhoto', () {
    final file = File('test/fixtures/test_image.png');

    test('emits loading then success state when upload succeeds', () async {
      when(mockUploadPhotoUseCase.call(file)).thenAnswer(
        (_) async => SuccessResponse(data: 'https://example.com/new.jpg'),
      );
      when(mockSessionController.user).thenReturn(driverEntity);
      when(mockSessionController.saveUser(any)).thenReturn(null);

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(UploadPhotoEvent(file));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0].uploadPhotoState?.isLoading, true);
      expect(states[1].uploadPhotoState?.isLoading, false);
      expect(states[1].uploadPhotoState?.data, 'https://example.com/new.jpg');

      await subscription.cancel();
    });

    test('emits loading then error state when upload fails', () async {
      when(
        mockUploadPhotoUseCase.call(file),
      ).thenAnswer((_) async => ErrorResponse(errorMessage: 'Upload failed'));

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(UploadPhotoEvent(file));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.length, 2);
      expect(states[0].uploadPhotoState?.isLoading, true);
      expect(states[1].uploadPhotoState?.isLoading, false);
      expect(states[1].uploadPhotoState?.errorMessage, 'Upload failed');

      await subscription.cancel();
    });

    test('updates session with new photo URL on success', () async {
      when(
        mockUploadPhotoUseCase.call(file),
      ).thenAnswer((_) async => SuccessResponse(data: 'https://new-url.com'));
      when(mockSessionController.user).thenReturn(driverEntity);
      when(mockSessionController.saveUser(any)).thenReturn(null);

      final states = <EditProfileStates>[];
      final subscription = viewModel.stream.listen(states.add);

      viewModel.doIntent(UploadPhotoEvent(file));
      await Future.delayed(const Duration(milliseconds: 100));

      final captured = verify(
        mockSessionController.saveUser(captureAny),
      ).captured;
      final savedUser = captured.last as DriverEntity;
      expect(savedUser.photoUrl, 'https://new-url.com');
      expect(savedUser.id, driverEntity.id);
      expect(savedUser.firstName, driverEntity.firstName);

      await subscription.cancel();
    });

    test(
      'does not update session when user is null on upload success',
      () async {
        when(
          mockUploadPhotoUseCase.call(file),
        ).thenAnswer((_) async => SuccessResponse(data: 'url'));
        when(mockSessionController.user).thenReturn(null);

        final states = <EditProfileStates>[];
        final subscription = viewModel.stream.listen(states.add);

        viewModel.doIntent(UploadPhotoEvent(file));
        await Future.delayed(const Duration(milliseconds: 100));

        verifyNever(mockSessionController.saveUser(any));

        await subscription.cancel();
      },
    );
  });
}
