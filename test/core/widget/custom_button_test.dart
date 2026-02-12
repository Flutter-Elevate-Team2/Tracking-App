import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/widget/custom_button.dart';

void main() {
  group('CustomButton', () {
    testWidgets('renders title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              title: 'Tap Me',
              onPressed: () {},
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Tap Me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              title: 'Tap Me',
              onPressed: () => pressed = true,
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isTrue);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomButton(
              title: 'Disabled',
              onPressed: null,
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });
  });
}
