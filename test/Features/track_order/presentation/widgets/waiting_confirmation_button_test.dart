import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/waiting_confirmation_button.dart';
import 'package:tracking_app/core/constants/app_colors.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const Scaffold(body: WaitingConfirmationButton()),
    );
  }

  group('WaitingConfirmationButton Coverage Tests', () {
    testWidgets('Should render all components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('Should be disabled and have correct style', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));

      expect(button.onPressed, isNull);

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(progressIndicator.strokeWidth, 2);
      expect(progressIndicator.color, AppColors.mainColor);
    });

    testWidgets('Should check layout structure for full coverage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Row), findsOneWidget);
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.center);

      expect(find.byType(Padding), findsWidgets);

      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
