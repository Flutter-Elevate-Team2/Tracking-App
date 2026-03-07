import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/Features/auth/presentation/apply/views/apply_screen.dart';
import 'package:tracking_app/Features/auth/presentation/apply/views/success_apply_screen.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/views/forget_password_screen_flow.dart';
import 'package:tracking_app/Features/auth/presentation/login/views/login_screen.dart';
import 'package:tracking_app/Features/auth/presentation/on_boarding/views/on_boarding_screen.dart';
import 'package:tracking_app/Features/order/domain/entities/driver_order_entity.dart';
import 'package:tracking_app/Features/order/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/presentation/views/screens/home_screen.dart';
import 'package:tracking_app/Features/home/presentation/views/screens/home_view.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/views/order_details.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/edit_profile_screen.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/edit_vehicle_screen.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/profile_screen.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/reset_password_screen.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_tracking_entity.dart';
import 'package:tracking_app/Features/track_order/presentation/views/order_map_screen.dart';
import 'package:tracking_app/Features/track_order/presentation/views/success_screen.dart';
import 'package:tracking_app/Features/track_order/presentation/views/track_order_screen.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/services/active_order_firestore_service.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/views/my_orders_screen.dart';
// coverage:ignore-file

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

  static const String mainProfilePath = '/mainprofile';
  static const String mainProfileName = 'mainProfile';

  static const String profilePath = '/profile';
  static const String profileName = 'profile';

  static const String editProfilePath = '/editprofile';
  static const String editProfileName = 'editProfile';

  static const String editVehiclePath = '/editvehicle';
  static const String editVehicleName = 'editVehicle';

  static const String ordersPath = '/orders';
  static const String ordersName = 'orders';

  static const String orderDetailsPath = '/ordersdetails';
  static const String orderDetailsName = 'ordersdetails';

  static const String trackOrderPath = '/trackorder';
  static const String trackOrderName = 'trackOrder';

  static const String successPath = '/success';
  static const String successName = 'success';

  static const String mapPath = '/map';
  static const String mapName = 'map';
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
    initialLocation: Routes.ordersPath,
    redirect: (context, state) async {
      final authRepo = getIt<AuthRepoContract>();
      final prefs = await SharedPreferences.getInstance();

      final bool isLoggedIn = await authRepo.isLoggedIn();

      final isAuthRoute =
          state.uri.toString() == Routes.onBoardingPath ||
          state.uri.toString() == Routes.loginPath;

      final isTrackingRoute =
          state.uri.toString().startsWith(Routes.trackOrderPath) ||
          state.uri.toString().startsWith(Routes.mapPath);
      if (!isLoggedIn) {
        return isAuthRoute ? null : Routes.loginPath;
      }

      if (isLoggedIn) {
        // Cold-start trap: Check Firestore for active orders
        final driverId = prefs.getString(ApiConstants.driverIdKey) ?? '';
        if (driverId.isNotEmpty && !isTrackingRoute) {
          final activeOrderService = getIt<ActiveOrderFirestoreService>();
          final activeOrderId = await activeOrderService.getActiveOrder(
            driverId,
          );
          if (activeOrderId != null) {
            return '${Routes.trackOrderPath}/$activeOrderId';
          }
        }
        if (isAuthRoute) {
          return Routes.homePath;
        }
      }
      return null;
    },
    routes: [
      // final authRepo = getIt<AuthRepoContract>();
      // final bool isLoggedIn = await authRepo.isLoggedIn();
      // final bool isLoggingIn = state.uri.toString() == Routes.signInPath;
      //
      // if (isLoggedIn && isLoggingIn) {
      //   return Routes.homePath;
      // }
      // return null;
      GoRoute(
        path: Routes.onBoardingPath,
        name: Routes.onBoardingName,
        builder: (context, state) => OnBoardingScreen(),
      ),
      GoRoute(
        path: '${Routes.orderDetailsPath}', // مثلا "/orderdetails"
        name: Routes.orderDetailsName,
        builder: (context, state) {
          final order = state.extra as DriverOrdersEntity?;

          return OrderDetailsDisplayBody(order: order!);
        },
      ),
      GoRoute(
        path: Routes.loginPath,
        name: Routes.loginName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routes.applyPath,
        name: Routes.applyName,
        builder: (context, state) => ApplyScreen(),
      ),
      GoRoute(
        path: Routes.successApplyPath,
        name: Routes.successApplyName,
        builder: (context, state) => SuccessApplyScreen(),
      ),

      GoRoute(
        path: Routes.forgetPasswordPath,
        name: Routes.forgetPasswordName,
        builder: (context, state) => ForgetPasswordScreenFlow(),
      ),
      GoRoute(
        path: Routes.verifyCodePath,
        name: Routes.verifyCodeName,
        builder: (context, state) => Container(),
      ),

      GoRoute(
        path: Routes.editVehiclePath,
        name: Routes.editVehicleName,
        builder: (context, state) => const EditVehicleScreen(),
      ),
      GoRoute(
        path: Routes.editProfilePath,
        name: Routes.editProfileName,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<EditProfileViewModel>(),
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: Routes.resetPasswordPath,
        name: Routes.resetPasswordName,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => getIt<ChangePasswordViewModel>(),
            child: const ResetPasswordScreen(),
          );
        },
      ),
      GoRoute(
        path: '${Routes.trackOrderPath}/:orderId',
        name: Routes.trackOrderName,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';

          return TrackOrderScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: Routes.mapPath,
        name: Routes.mapName,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final order = extras['order'] as OrderTrackingEntity;
          final isPickup = extras['isPickup'] as bool;

          return OrderMapScreen(order: order, initialShowPickup: isPickup);
        },
      ),

      GoRoute(
        path: Routes.successPath,
        name: Routes.successName,
        builder: (context, state) => const SuccessScreen(),
      ),
      // / ====== MAIN SHELL ROUTE (BOTTOM NAV BAR) ======
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.homePath,
                name: Routes.homeName,
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),
          // Branch 2: Orders
          StatefulShellBranch(
            navigatorKey: _ordersNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.ordersPath,
                name: Routes.ordersName,
                builder: (context, state) => MyOrdersScreen(),
              ),
            ],
          ),

          // Branch 3: Profile
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.mainProfilePath,
                name: Routes.mainProfileName,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
