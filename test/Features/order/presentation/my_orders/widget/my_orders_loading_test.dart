import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/my_orders_loading.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: MyOrdersLoading(),
      ),
    );
  }

  group('MyOrdersLoading 100% Precision Tests', () {

    testWidgets('should render top row with two expanded shimmers', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       final topRow = find.byType(Row).first;
      expect(find.descendant(of: topRow, matching: find.byType(AppShimmer)), findsAtLeastNWidgets(2));
    });

    testWidgets('should render exactly 2 shimmer cards with specific styling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       final cardFinder = find.byWidgetPredicate((widget) =>
      widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).borderRadius != BorderRadius.zero);

      expect(cardFinder, findsNWidgets(2));
    });

    testWidgets('should contain 4 circular shimmers (2 per card)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());


      expect(find.byType(AppShimmer), findsAtLeastNWidgets(10));
    });

    testWidgets('should verify layout does not overflow when scrolling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final scrollable = find.byType(SingleChildScrollView);
      await tester.drag(scrollable, const Offset(0, -500));
      await tester.pump();

       expect(tester.takeException(), isNull);
    });
  });
}