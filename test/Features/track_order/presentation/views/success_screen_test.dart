import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/track_order/presentation/views/success_screen.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/custom_button.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockRouter;

  setUp(() {
    mockRouter = MockGoRouter();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: const SuccessScreen(),
      ),
    );
  }

  group('SuccessScreen UI and Navigation Tests', () {
    testWidgets('Should display all UI elements correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(Lottie), findsOneWidget);

      expect(find.textContaining(''), findsWidgets);

      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('Should navigate to Home when Done button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final doneButton = find.byType(CustomButton);
      await tester.tap(doneButton);

      await tester.pump();

      verify(mockRouter.goNamed(Routes.homeName)).called(1);
    });

    testWidgets('Should apply correct layout and padding', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final paddingFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Padding && widget.padding == const EdgeInsets.all(24),
      );

      expect(paddingFinder, findsOneWidget);

      final columnFinder = find.byType(Column);
      expect(columnFinder, findsOneWidget);

      final columnWidget = tester.widget<Column>(columnFinder);
      expect(columnWidget.mainAxisAlignment, MainAxisAlignment.center);

      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
