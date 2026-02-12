import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/Features/home/presentation/views/screens/home_screen.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/custom_button_nav_bar.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

// Helper to create a test app with the HomeScreen in a real router environment
Widget createTestApp() {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final ordersNavigatorKey = GlobalKey<NavigatorState>();
  final profileNavigatorKey = GlobalKey<NavigatorState>();

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) =>
                    const Scaffold(body: Text('Home Screen')),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: ordersNavigatorKey,
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) =>
                    const Scaffold(body: Text('Orders Screen')),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    const Scaffold(body: Text('Profile Screen')),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should render HomeScreen with CustomButtonNavigationBar', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verify HomeScreen is rendered
      expect(find.byType(HomeScreen), findsOneWidget);

      // Verify CustomButtonNavigationBar is rendered
      expect(find.byType(CustomButtonNavigationBar), findsOneWidget);

      // Verify initial tab content is shown
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets(
      'should navigate between tabs using the bottom navigation bar',
      (tester) async {
        await tester.pumpWidget(createTestApp());
        await tester.pumpAndSettle();

        // Verify initial state (Home)
        expect(find.text('Home Screen'), findsOneWidget);
        expect(find.text('Orders Screen'), findsNothing);

        // Tap on Orders tab (assuming it's the second item)
        await tester.tap(find.byIcon(Icons.fact_check_outlined));
        await tester.pumpAndSettle();

        // Verify Orders tab is active
        expect(find.text('Orders Screen'), findsOneWidget);
        expect(find.text('Home Screen'), findsNothing);

        // Tap on Profile tab (assuming it's the third item)
        await tester.tap(find.byIcon(Icons.person_outline));
        await tester.pumpAndSettle();

        // Verify Profile tab is active
        expect(find.text('Profile Screen'), findsOneWidget);
        expect(find.text('Orders Screen'), findsNothing);
      },
    );
  });
}
