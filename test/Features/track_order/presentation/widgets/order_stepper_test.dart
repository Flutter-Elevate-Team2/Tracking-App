import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/order_stepper.dart';
import 'package:tracking_app/core/constants/app_colors.dart';

void main() {
  Widget createWidgetUnderTest({required int currentStep, bool isLoading = false}) {
    return MaterialApp(
      home: Scaffold(
        body: OrderStepper(
          currentStep: currentStep,
          isLoading: isLoading,
        ),
      ),
    );
  }

  group('OrderStepper Widget Tests', () {
    testWidgets('should render 5 steps (containers)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(currentStep: 0));

       expect(find.byType(Expanded), findsNWidgets(5));
    });

    testWidgets('should color completed steps with green', (tester) async {
       const currentStep = 2;
      await tester.pumpWidget(createWidgetUnderTest(currentStep: currentStep));

       final containers = tester.widgetList<Container>(find.byType(Container));

      int index = 0;
      for (var container in containers) {
        final decoration = container.decoration as BoxDecoration;
        if (index <= currentStep) {
          expect(decoration.color, AppColors.green);
        } else {
          expect(decoration.color, AppColors.lightGray);
        }
        index++;
      }
    });

    testWidgets('should show LinearProgressIndicator only on the NEXT step when isLoading is true', (tester) async {
      const currentStep = 1;
      await tester.pumpWidget(createWidgetUnderTest(currentStep: currentStep, isLoading: true));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);

       final containers = tester.widgetList<Container>(find.byType(Container)).toList();
      expect(containers[2].child, isA<LinearProgressIndicator>());
      expect(containers[1].child, isNull);
      expect(containers[3].child, isNull);
    });

    testWidgets('should NOT show LinearProgressIndicator when isLoading is false', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(currentStep: 1, isLoading: false));

      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('should have correct height and margin styling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(currentStep: 0));

      final firstContainer = tester.widget<Container>(find.byType(Container).first);

      expect(firstContainer.constraints?.minHeight, 4.0);
      expect(firstContainer.margin, const EdgeInsets.symmetric(horizontal: 2));
    });
  });
}