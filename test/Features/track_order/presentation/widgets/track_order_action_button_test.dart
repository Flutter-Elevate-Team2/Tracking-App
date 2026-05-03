import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/domain/entities/order_status.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_action_button.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createWidgetUnderTest({
    required OrderStatus status,
    required VoidCallback onPressed,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: OrderActionButton(
          status: status,
          onPressed: onPressed,
        ),
      ),
    );
  }

  group('OrderActionButton Widget Tests', () {
    testWidgets('should call onPressed when status is NOT delivered', (tester) async {
      bool isPressed = false;

      await tester.pumpWidget(createWidgetUnderTest(
        status: OrderStatus.arrivedUser,
        onPressed: () => isPressed = true,
      ));

       await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(isPressed, isTrue);
    });

    testWidgets('should NOT call onPressed when status is delivered (button disabled)', (tester) async {
      bool isPressed = false;

      await tester.pumpWidget(createWidgetUnderTest(
        status: OrderStatus.delivered,
        onPressed: () => isPressed = true,
      ));

       await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

       expect(isPressed, isFalse);

       final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });

    testWidgets('should display text from status.getButtonText', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        status: OrderStatus.arrivedUser,
        onPressed: () {},
      ));

      final textFinder = find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.byType(Text),
      );

      expect(textFinder, findsOneWidget);
      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.data, isNotEmpty);
    });
  });
}