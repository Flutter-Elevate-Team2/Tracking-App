import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/order_state.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

void main() {
  Widget createWidgetUnderTest(String stateText) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: Row(
          children: [OrderState(stateText)],
        ),
      ),
    );
  }

  group('OrderState Widget Tests', () {
    testWidgets('should show red cancel icon when state is cancelled', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(''));
      final BuildContext context = tester.element(find.byType(OrderState));

       final String cancelledText = AppLocalizations.of(context)!.cancelled.toLowerCase();

       await tester.pumpWidget(createWidgetUnderTest(cancelledText));
      await tester.pump();

      // Assert
      expect(find.text(cancelledText), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text(cancelledText));
      expect(textWidget.style?.color, AppColors.red);
    });

    testWidgets('should show green check icon when state is completed', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(''));
      final BuildContext context = tester.element(find.byType(OrderState));
      final String completedText = AppLocalizations.of(context)!.completed.toLowerCase();

      await tester.pumpWidget(createWidgetUnderTest(completedText));
      await tester.pump();

      expect(find.text(completedText), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(tester.widget<Text>(find.text(completedText)).style?.color, AppColors.green);
    });
  });
}