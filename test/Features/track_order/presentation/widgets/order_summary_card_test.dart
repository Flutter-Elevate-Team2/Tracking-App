import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_summary_card.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  const String testTotal = "550.0";
  const String testPaymentMethod = "Cash on Delivery";

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OrderSummaryCard(
          total: testTotal,
          paymentMethod: testPaymentMethod,
        ),
      ),
    );
  }

  group('OrderSummaryCard Widget Tests', () {
    testWidgets('should display total price with currency correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.textContaining('Total'), findsOneWidget);

       expect(find.textContaining(testTotal), findsOneWidget);
    });

    testWidgets('should display payment method correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(
          find.byWidgetPredicate(
                  (widget) => widget is Text &&
                  widget.data!.toLowerCase().contains('payment method')
          ),
          findsOneWidget
      );
    });

    testWidgets('should render two rows with correct decoration', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       final containerFinder = find.byType(Container);
      expect(containerFinder, findsNWidgets(2));

       final container = tester.widget<Container>(containerFinder.first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, BorderRadius.circular(10));
      expect(decoration.border, isNotNull);
      expect(decoration.boxShadow, isNotEmpty);
    });
  });
}