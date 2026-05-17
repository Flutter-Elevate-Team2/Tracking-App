import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/Features/auth/domain/use_cases/login_use_cases/login_use_case.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';
import 'package:tracking_app/core/services/firebase_order_service.dart';

import 'login_view_model_test.mocks.dart';

@GenerateMocks([
  LoginUseCase,
  SessionController,
  LoginEntity,
  ActiveOrderFirestoreService,
  GetDriverProfileUseCase,
  FirebaseOrderService,
])
void main() {
  provideDummy<BaseResponse<LoginEntity>>(
    SuccessResponse(data: MockLoginEntity()),
  );
  provideDummy<BaseResponse<DriverEntity>>(
    ErrorResponse(errorMessage: 'dummy'),
  );

  late MockLoginUseCase mockUseCase;
  late MockSessionController mockSessionController;
  late MockActiveOrderFirestoreService mockActiveOrderService;
  late MockGetDriverProfileUseCase mockGetProfileUseCase;
  late MockFirebaseOrderService mockFirebaseOrderService;
  late LoginViewModel loginViewModel;

  final tDriver = DriverEntity(
    id: 'test_driver_id',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@test.com',
    phone: '12345',
    photo: '',
    role: 'driver',
    gender: 'male',
    country: 'EG',
    vehicleType: 'Car',
    vehicleNumber: '123',
    vehicleLicense: 'abc',
    nid: '111',
    nidImg: '',
  );

  setUp(() {
    mockUseCase = MockLoginUseCase();
    mockSessionController = MockSessionController();
    mockActiveOrderService = MockActiveOrderFirestoreService();
    mockGetProfileUseCase = MockGetDriverProfileUseCase();
    mockFirebaseOrderService = MockFirebaseOrderService();

    when(
      mockActiveOrderService.getActiveOrder(any),
    ).thenAnswer((_) async => null);
    when(
      mockGetProfileUseCase.call(),
    ).thenAnswer((_) async => SuccessResponse(data: tDriver));

    SharedPreferences.setMockInitialValues({});
    loginViewModel = LoginViewModel(
      mockUseCase,
      mockSessionController,
      mockActiveOrderService,
      mockGetProfileUseCase,
      mockFirebaseOrderService,
    );
  });

  tearDown(() {
    loginViewModel.close();
  });

  group('LoginViewModel Complete Tests', () {
    test('Initial state should be LoginState with default values', () {
      expect(loginViewModel.state.isRememberMe, false);
      expect(loginViewModel.state.loginState, isNull);
      expect(loginViewModel.state.loginState?.isLoading, isNull);
      expect(loginViewModel.state.activeOrderId, isNull);
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
      'emits [Loading, Success] with no active order when login succeeds and no active order',
      build: () {
        when(
          mockUseCase.call(any, isRememberMe: anyNamed('isRememberMe')),
        ).thenAnswer(
          (_) async => SuccessResponse<LoginEntity>(data: tLoginEntity),
        );
        when(
          mockActiveOrderService.getActiveOrder(any),
        ).thenAnswer((_) async => null);
        when(
          mockGetProfileUseCase.call(),
        ).thenAnswer((_) async => SuccessResponse(data: tDriver));
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
            .having((s) => s.loginState?.isLoading, 'isLoading', false)
            .having((s) => s.activeOrderId, 'activeOrderId', isNull),
      ],
      verify: (_) {
        verify(mockSessionController.notifyLogin()).called(1);
        verify(mockGetProfileUseCase.call()).called(1);
        verify(mockSessionController.saveUser(tDriver)).called(1);
      },
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [Loading, Success] with active order when login succeeds and active order exists',
      build: () {
        when(
          mockUseCase.call(any, isRememberMe: anyNamed('isRememberMe')),
        ).thenAnswer(
          (_) async => SuccessResponse<LoginEntity>(data: tLoginEntity),
        );
        when(
          mockActiveOrderService.getActiveOrder(any),
        ).thenAnswer((_) async => 'order_456');
        when(
          mockGetProfileUseCase.call(),
        ).thenAnswer((_) async => SuccessResponse(data: tDriver));
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
            .having((s) => s.loginState?.isLoading, 'isLoading', false)
            .having((s) => s.activeOrderId, 'activeOrderId', 'order_456'),
      ],
      verify: (_) {
        verify(mockSessionController.notifyLogin()).called(1);
        verify(mockGetProfileUseCase.call()).called(1);
        verify(
          mockActiveOrderService.getActiveOrder('test_driver_id'),
        ).called(1);
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
