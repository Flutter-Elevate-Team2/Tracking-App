import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/presentation/on_boarding/views/on_boarding_screen.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'on_boarding_screen_test.mocks.dart';

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();

    when(
      mockRouter.pushNamed(
        any,
        pathParameters: anyNamed('pathParameters'),
        queryParameters: anyNamed('queryParameters'),
        extra: anyNamed('extra'),
      ),
    ).thenAnswer((_) async => null);
  });

  Widget createWidgetUnderTest() {
    return InheritedGoRouter(
      goRouter: mockRouter,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const OnBoardingScreen(),
      ),
    );
  }

  group('OnBoardingScreen Coverage 100%', () {
    testWidgets('Should display all UI components and verify layout keys', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byKey(const Key("onBoardingLottie")), findsOneWidget);
      expect(find.byKey(const Key("welcomeTo")), findsOneWidget);
      expect(find.byKey(const Key("floweryRiderApp")), findsOneWidget);
      expect(find.byKey(const Key("loginButtonOnBoarding")), findsOneWidget);
      expect(find.byKey(const Key("applyButtonOnBoarding")), findsOneWidget);
      expect(find.byKey(const Key("versionOnBoarding")), findsOneWidget);

      expect(find.textContaining('Login'), findsWidgets);
    });

    testWidgets('Should push login screen when login button is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final loginButton = find
          .descendant(
            of: find.byKey(const Key("loginButtonOnBoarding")),
            matching: find.byType(InkWell),
          )
          .first;

      await tester.tap(loginButton);
      await tester.pump();

      verify(mockRouter.pushNamed(Routes.loginName)).called(1);
    });

    testWidgets(
      'Should unfocus and push apply screen when apply button is tapped',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        final applyButton = find
            .descendant(
              of: find.byKey(const Key("applyButtonOnBoarding")),
              matching: find.byType(InkWell),
            )
            .first;

        await tester.tap(applyButton);
        await tester.pump();

        verify(mockRouter.pushNamed(Routes.applyName)).called(1);
      },
    );

    testWidgets('Verify Lottie asset is loaded correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final lottieFinder = find.byKey(const Key("onBoardingLottie"));
      expect(lottieFinder, findsOneWidget);
    });
  });
}
