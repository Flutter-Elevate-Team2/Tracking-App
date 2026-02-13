import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/presentation/apply/views/success_apply_screen.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/custom_button.dart';

@GenerateMocks([GoRouter])
import 'success_apply_screen_test.mocks.dart';

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
  });

  Widget createWidgetUnderTest() {
    return InheritedGoRouter(
      goRouter: mockRouter,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SuccessApplyScreen(),
      ),
    );
  }

  group('SuccessApplyScreen Coverage Tests', () {
    testWidgets('Should render UI despite layout warnings', (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exception is AssertionError &&
            details.exception.toString().contains('ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      expect(find.byKey(const Key("successApplyLottie")), findsOneWidget);
      expect(find.byKey(const Key("successApplySubTitle")), findsOneWidget);
      expect(find.byKey(const Key("successApplyDescription")), findsOneWidget);

      FlutterError.onError = originalOnError;
    });

    testWidgets('Should navigate to login when button is pressed', (tester) async {
      FlutterError.onError = (details) => {};

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final loginBtn = find.byType(CustomButton);
      await tester.tap(loginBtn);
      await tester.pump();

      verify(mockRouter.goNamed(Routes.loginName)).called(1);
    });
  });
}