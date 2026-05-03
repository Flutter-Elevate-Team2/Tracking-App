import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_status_header.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
   final testDate = DateTime(2023, 10, 25, 14, 30);
  const testOrderId = "ORD-999";
  const testStatus = OrderStatus.arrivedUser;

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: OrderStatusHeader(
          status: testStatus,
          orderId: testOrderId,
          date: testDate,
        ),
      ),
    );
  }

  group('OrderStatusHeader Widget Tests', () {

    testWidgets('should render status, order ID, and formatted date correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.textContaining(testOrderId), findsOneWidget);


      expect(find.textContaining('Status'), findsOneWidget);

      final expectedDateString = DateFormat('EEE, dd MMM yyyy, hh:mm a').format(testDate);
      expect(find.text(expectedDateString), findsOneWidget);
    });

    testWidgets('should have correct background color and styling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, BorderRadius.circular(10));
    });

    testWidgets('should apply specific text styles to Status and OrderID', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       final statusText = tester.widget<Text>(find.textContaining('Status'));
      expect(statusText.style?.fontWeight, FontWeight.bold);
      expect(statusText.style?.fontSize, 16);

      final dateText = tester.widget<Text>(find.text(DateFormat('EEE, dd MMM yyyy, hh:mm a').format(testDate)));
      expect(dateText.style?.fontSize, 14);
    });
  });
}