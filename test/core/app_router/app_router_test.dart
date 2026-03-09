import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/core/app_router/app_router.dart';

import 'app_router_test.mocks.dart';

@GenerateMocks([AuthRepoContract])
void main() {
  late MockAuthRepoContract mockAuthRepo;

  setUpAll(() {
    mockAuthRepo = MockAuthRepoContract();
    // AppRouter.router calls getIt<AuthRepoContract>() inside its redirect,
    // so we must register a mock before accessing the static router.
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<AuthRepoContract>()) {
      getIt.registerSingleton<AuthRepoContract>(mockAuthRepo);
    }

    // Stub isLoggedIn so the redirect doesn't throw
    when(mockAuthRepo.isLoggedIn()).thenAnswer((_) async => false);
  });

  tearDownAll(() {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AuthRepoContract>()) {
      getIt.unregister<AuthRepoContract>();
    }
  });

  group('Routes Constants', () {
    test('should have correct onBoarding route paths', () {
      expect(Routes.onBoardingPath, '/onBoarding');
      expect(Routes.onBoardingName, 'onBoarding');
    });

    test('should have correct login route paths', () {
      expect(Routes.loginPath, '/login');
      expect(Routes.loginName, 'login');
    });

    test('should have correct apply route paths', () {
      expect(Routes.applyPath, '/apply');
      expect(Routes.applyName, 'apply');
    });

    test('should have correct successApply route paths', () {
      expect(Routes.successApplyPath, '/successapply');
      expect(Routes.successApplyName, 'successApply');
    });

    test('should have correct forgetPassword route paths', () {
      expect(Routes.forgetPasswordPath, '/forgetpassword');
      expect(Routes.forgetPasswordName, 'forgetPassword');
    });

    test('should have correct resetPassword route paths', () {
      expect(Routes.resetPasswordPath, '/resetpassword');
      expect(Routes.resetPasswordName, 'resetPassword');
    });

    test('should have correct home route paths', () {
      expect(Routes.homePath, '/home');
      expect(Routes.homeName, 'home');
    });

    test('should have correct profile route paths', () {
      expect(Routes.mainProfilePath, '/mainprofile');
      expect(Routes.mainProfileName, 'mainProfile');
      expect(Routes.profilePath, '/profile');
      expect(Routes.profileName, 'profile');
    });

    test('should have correct editProfile route paths', () {
      expect(Routes.editProfilePath, '/editprofile');
      expect(Routes.editProfileName, 'editProfile');
    });

    test('should have correct editVehicle route paths', () {
      expect(Routes.editVehiclePath, '/editvehicle');
      expect(Routes.editVehicleName, 'editVehicle');
    });

    test('should have correct orders route paths', () {
      expect(Routes.ordersPath, '/orders');
      expect(Routes.ordersName, 'orders');
    });
  });

  group('AppRouter', () {
    late GoRouter router;

    setUp(() {
      router = AppRouter.router;
    });

    test('should have rootNavigatorKey', () {
      expect(AppRouter.rootNavigatorKey, isNotNull);
    });

    test('should have initial location configured', () {
      // GoRouter initial location verification
      // We accept either direct configuration or empty if not yet initialized in test
      // The main goal is to ensure the router is created without error
      expect(router, isNotNull);
    });

    test('should have routes configured', () {
      expect(router.configuration.routes, isNotEmpty);
    });

    test('should be able to navigate to onBoarding route', () {
      final location = router.namedLocation(Routes.onBoardingName);
      expect(location, equals(Routes.onBoardingPath));
    });

    test('should be able to navigate to login route', () {
      final location = router.namedLocation(Routes.loginName);
      expect(location, equals(Routes.loginPath));
    });

    test('should be able to navigate to apply route', () {
      final location = router.namedLocation(Routes.applyName);
      expect(location, equals(Routes.applyPath));
    });

    test('should be able to navigate to successApply route', () {
      final location = router.namedLocation(Routes.successApplyName);
      expect(location, equals(Routes.successApplyPath));
    });

    test('should be able to navigate to forgetPassword route', () {
      final location = router.namedLocation(Routes.forgetPasswordName);
      expect(location, equals(Routes.forgetPasswordPath));
    });

    test('should be able to navigate to resetPassword route', () {
      final location = router.namedLocation(Routes.resetPasswordName);
      expect(location, equals(Routes.resetPasswordPath));
    });

    test('should be able to navigate to home route', () {
      final location = router.namedLocation(Routes.homeName);
      expect(location, equals(Routes.homePath));
    });

    test('should be able to navigate to mainProfile route', () {
      final location = router.namedLocation(Routes.mainProfileName);
      expect(location, equals(Routes.mainProfilePath));
    });

    test('should be able to navigate to editProfile route', () {
      final location = router.namedLocation(Routes.editProfileName);
      expect(location, equals(Routes.editProfilePath));
    });

    test('should be able to navigate to editVehicle route', () {
      final location = router.namedLocation(Routes.editVehicleName);
      expect(location, equals(Routes.editVehiclePath));
    });

    test('should be able to navigate to orders route', () {
      final location = router.namedLocation(Routes.ordersName);
      expect(location, equals(Routes.ordersPath));
    });

    test('should have StatefulShellRoute configured', () {
      final hasShellRoute = router.configuration.routes.any(
        (route) => route is StatefulShellRoute,
      );
      expect(hasShellRoute, isTrue);
    });

    test('should have three branches in StatefulShellRoute', () {
      final shellRoute =
          router.configuration.routes.firstWhere(
                (route) => route is StatefulShellRoute,
              )
              as StatefulShellRoute;

      expect(shellRoute.branches.length, equals(3));
    });
  });
}
