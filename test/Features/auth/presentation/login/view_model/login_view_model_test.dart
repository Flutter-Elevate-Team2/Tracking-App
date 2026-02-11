import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/Features/auth/domain/use_cases/login_use_cases/login_use_case.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

import 'login_view_model_test.mocks.dart';

@GenerateMocks([LoginUseCase, SessionController, LoginEntity])
void main() {
  provideDummy<BaseResponse<LoginEntity>>(
    SuccessResponse(data: MockLoginEntity()),
  );

  late MockLoginUseCase mockUseCase;
  late MockSessionController mockSessionController;
  late LoginViewModel loginViewModel;

  setUp(() {
    mockUseCase = MockLoginUseCase();
    mockSessionController = MockSessionController();
    loginViewModel = LoginViewModel(mockUseCase, mockSessionController);
  });

  tearDown(() {
    loginViewModel.close();
  });

  group('LoginViewModel Complete Tests', () {
    test('Initial state should be LoginState with default values', () {
      expect(loginViewModel.state.isRememberMe, false);
      expect(loginViewModel.state.loginState, isNull);
      expect(loginViewModel.state.loginState?.isLoading, isNull);
    });

    blocTest<LoginViewModel, LoginState>(
      'emits [isRememberMe: true] when ToggleRememberMeEvent is added',
      build: () => loginViewModel,
      act: (bloc) => bloc.doIntent(ToggleRememberMeEvent()),
      expect: () => [
        isA<LoginState>().having((s) => s.isRememberMe, 'isRememberMe', true),
      ],
    );

    final tLoginEntity = MockLoginEntity();
    final tLoginEvent = LoginButtonClickedEvent(
      email: 'test@example.com',
      password: 'password123',
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [Loading, Success] and notifies session when login is successful',
      build: () {
        when(
          mockUseCase.call(any, isRememberMe: anyNamed('isRememberMe')),
        ).thenAnswer(
          (_) async => SuccessResponse<LoginEntity>(data: tLoginEntity),
        );
        return loginViewModel;
      },
      act: (bloc) => bloc.doIntent(tLoginEvent),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState?.isLoading,
          'isLoading',
          true,
        ),
        isA<LoginState>()
            .having((s) => s.loginState?.data, 'data', tLoginEntity)
            .having((s) => s.loginState?.isLoading, 'isLoading', false),
      ],
      verify: (_) {
        verify(mockSessionController.notifyLogin()).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [Loading, Error] when login fails with ErrorResponse',
      build: () {
        when(
          mockUseCase.call(any, isRememberMe: anyNamed('isRememberMe')),
        ).thenAnswer(
          (_) async =>
              ErrorResponse<LoginEntity>(errorMessage: 'Invalid credentials'),
        );
        return loginViewModel;
      },
      act: (bloc) => bloc.doIntent(tLoginEvent),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState?.isLoading,
          'isLoading',
          true,
        ),
        isA<LoginState>()
            .having(
              (s) => s.loginState?.errorMessage,
              'errorMessage',
              'Invalid credentials',
            )
            .having((s) => s.loginState?.isLoading, 'isLoading', false),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits state with reset loginState when UserTypingEvent is added after an error',
      build: () => loginViewModel,
      seed: () => LoginState(loginState: BaseState(errorMessage: 'Old Error')),
      act: (bloc) => bloc.doIntent(UserTypingEvent()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState?.errorMessage,
          'errorMessage',
          null,
        ),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits default state when LoginInitialEvent is added',
      build: () => loginViewModel,
      seed: () => LoginState(isRememberMe: true),
      act: (bloc) => bloc.doIntent(LoginInitialEvent()),
      expect: () => [
        isA<LoginState>().having((s) => s.isRememberMe, 'isRememberMe', false),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'does NOT reset loading state if user types while request is still in progress',
      build: () => loginViewModel,
      seed: () => LoginState(loginState: BaseState(isLoading: true)),
      act: (bloc) => bloc.doIntent(UserTypingEvent()),
      expect: () => [
        isA<LoginState>().having(
          (s) => s.loginState?.isLoading,
          'isLoading',
          false,
        ),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'should clear old data when a new login request fails',
      build: () {
        when(
          mockUseCase.call(any, isRememberMe: anyNamed('isRememberMe')),
        ).thenAnswer(
          (_) async => ErrorResponse<LoginEntity>(errorMessage: 'New Error'),
        );
        return loginViewModel;
      },
      seed: () => LoginState(loginState: BaseState(data: MockLoginEntity())),
      act: (bloc) => bloc.doIntent(tLoginEvent),
      expect: () => [
        isA<LoginState>()
            .having((s) => s.loginState?.isLoading, 'isLoading', true)
            .having((s) => s.loginState?.data, 'data', null),
        isA<LoginState>().having(
          (s) => s.loginState?.errorMessage,
          'errorMessage',
          'New Error',
        ),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'should reset loginState entirely when user starts typing',
      build: () => loginViewModel,
      seed: () => LoginState(
        loginState: BaseState(errorMessage: 'Invalid', data: MockLoginEntity()),
      ),
      act: (bloc) => bloc.doIntent(UserTypingEvent()),
      expect: () => [
        isA<LoginState>()
            .having((s) => s.loginState?.errorMessage, 'error', null)
            .having((s) => s.loginState?.data, 'data', null),
      ],
    );
    test(
      'LoginState copyWith should return same object if no arguments are passed',
      () {
        const state = LoginState(isRememberMe: true);
        final result = state.copyWith();
        expect(result, state);
        expect(result.isRememberMe, true);
      },
    );

    test('LoginState props should contain all fields', () {
      const state = LoginState(isRememberMe: true);
      expect(state.props, containsAll([null, true]));
    });
  });
}
