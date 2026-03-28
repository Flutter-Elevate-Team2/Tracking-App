import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/order/presentation/my_orders/widget/num_of_orders_state.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

void main() {
  Widget createWidgetUnderTest({
    required int completed,
    required int canceled,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: NumOfOrdersState(
          completedOrders: completed,
          canceledOrders: canceled,
        ),
      ),
    );
  }

  group('NumOfOrdersState Widget Tests', () {
    testWidgets('should display correct numbers for completed and canceled orders', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(completed: 15, canceled: 3));
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should render icons correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(completed: 5, canceled: 1));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    });

    testWidgets('should apply background color with alpha correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(completed: 1, canceled: 1));

      final containers = find.byType(Container);
      expect(containers, findsNWidgets(2));

      final firstContainer = tester.widget<Container>(containers.first);
      final decoration = firstContainer.decoration as BoxDecoration;

      expect(decoration.color, AppColors.mainColor.withAlpha(30));
    });
  });
}