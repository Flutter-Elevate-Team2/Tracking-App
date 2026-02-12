import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/presentation/on_boarding/views/on_boarding_screen.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

@GenerateMocks([GoRouter])
import 'on_boarding_screen_test.mocks.dart';

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
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

    testWidgets('Should display all static elements with correct localized text', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // نستخدم pump() بدلاً من pumpAndSettle() لتجنب تعليق الأنيميشن
      await tester.pump();

      expect(find.byKey(const Key("onBoardingLottie")), findsOneWidget);
      expect(find.byKey(const Key("welcomeTo")), findsOneWidget);
      expect(find.byKey(const Key("floweryRiderApp")), findsOneWidget);
      expect(find.byKey(const Key("versionOnBoarding")), findsOneWidget);

      expect(find.textContaining('Login'), findsWidgets);
    });

    testWidgets('Should navigate to Login screen when login button is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final loginButton = find.byKey(const Key("loginButtonOnBoarding"));
      await tester.tap(loginButton);

      // نستخدم pump() لمعالجة ضغطة الزر فقط
      await tester.pump();

      verify(mockRouter.goNamed(Routes.loginName)).called(1);
    });

    testWidgets('Should navigate to Apply screen when apply button is pressed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final applyButton = find.byKey(const Key("applyButtonOnBoarding"));
      await tester.tap(applyButton);
      await tester.pump();

      verify(mockRouter.goNamed(Routes.applyName)).called(1);
    });
  });
}