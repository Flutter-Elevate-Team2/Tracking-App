import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {

  static const String onBoardingPath = '/onBoarding';
  static const String onBoardingName = 'onBoarding';


  static const String loginPath = '/login';
  static const String loginName = 'login';

  static const String applyPath = '/apply';
  static const String applyName = 'apply';


  static const String successApplyPath = '/successapply';
  static const String successApplyName = 'successApply';

  static const String forgetPasswordPath = '/forgetpassword';
  static const String forgetPasswordName = 'forgetPassword';


  static const String verifyCodePath = '/verifycode';
  static const String verifyCodeName = 'verifyCode';


  static const String resetPasswordPath = '/resetpassword';
  static const String resetPasswordName = 'resetPassword';

  // Home Tabs Paths
  static const String homePath = '/home';
  static const String homeName = 'home';


  static const String profilePath = '/profile';
  static const String profileName = 'profile';



  static const String editProfilePath = '/editprofile';
  static const String editProfileName = 'editProfile';


  static const String editVehiclePath = '/editvehicle';
  static const String editVehicleName = 'editVehicle';


  static const String ordersPath = '/orders';
  static const String ordersName = 'orders';


}

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _ordersNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _profileNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.onBoardingPath,
    redirect: (context, state) async {
      // final authRepo = getIt<AuthRepoContract>();
      // final bool isLoggedIn = await authRepo.isLoggedIn();
      // final bool isLoggingIn = state.uri.toString() == Routes.signInPath;
      //
      // if (isLoggedIn && isLoggingIn) {
      //   return Routes.homePath;
      // }
      // return null;
    },
    routes: [
      GoRoute(
        path: Routes.onBoardingPath,
        name: Routes.onBoardingName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.loginPath,
        name: Routes.loginName,
        builder: (context, state) =>  Container(),
      ),
      GoRoute(
        path: Routes.applyPath,
        name: Routes.applyName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.successApplyPath,
        name: Routes.successApplyName,
        builder: (context, state) => Container(),
      ),

      GoRoute(
        path: Routes.forgetPasswordPath,
        name: Routes.forgetPasswordName,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: Routes.verifyCodePath,
        name: Routes.verifyCodeName,
        builder: (context, state) => Container(),
      ),

      GoRoute(
        path: Routes.resetPasswordPath,
        name: Routes.resetPasswordName,
        builder: (context, state) => Container(),
      ),

      GoRoute(
        path: Routes.editProfilePath,
        name: Routes.editProfileName,
        builder: (context, state) => Container(),
      ),

      GoRoute(
        path: Routes.editVehiclePath,
        name: Routes.editVehicleName,
        builder: (context, state) => Container(),
      ),


      /// ====== MAIN SHELL ROUTE (BOTTOM NAV BAR) ======
      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     return HomeScreen(navigationShell: navigationShell);
      //   },
      //   branches: [
      //     // Branch 1: Home
      //     StatefulShellBranch(
      //       navigatorKey: _homeNavigatorKey,
      //       routes: [
      //         GoRoute(
      //           path: Routes.homePath,
      //           name: Routes.homeName,
      //           builder: (context, state) =>  Container(),
      //         ),
      //       ],
      //     ),
      //
      //     // Branch 2: Orders
      //     StatefulShellBranch(
      //       navigatorKey: _ordersNavigatorKey,
      //       routes: [
      //         GoRoute(
      //           path: Routes.ordersPath,
      //           name: Routes.ordersName,
      //           builder: (context, state) =>  Container(),
      //         ),
      //       ],
      //     ),
      //
      //     // Branch 3: Profile
      //     StatefulShellBranch(
      //       navigatorKey: _profileNavigatorKey,
      //       routes: [
      //         GoRoute(
      //           path: Routes.profilePath,
      //           name: Routes.profileName,
      //           builder: (context, state) =>  Container(),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    ],
  );
}
