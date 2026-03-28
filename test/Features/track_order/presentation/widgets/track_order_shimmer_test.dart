import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/track_order/presentation/widgets/track_order_shimmer.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TrackOrderShimmer(),
    );
  }

  group('TrackOrderShimmer Widget Tests', () {
    testWidgets('should render the correct number of shimmer components', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(AppBar), findsOneWidget);

      final stepperShimmers = find.descendant(
        of: find.byType(Row).first,
        matching: find.byType(AppShimmer),
      );
      expect(stepperShimmers, findsNWidgets(5));

      expect(find.byWidgetPredicate((widget) =>
      widget is AppShimmer && widget.radius >= 20), findsAtLeastNWidgets(4));
    });

    testWidgets('should display bottom sheet shimmer for the action button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final actionButtonShimmer = find.descendant(
        of: find.byWidgetPredicate((widget) => widget is Scaffold && widget.bottomSheet != null),
        matching: find.byType(AppShimmer),
      ).last;

       expect(actionButtonShimmer, findsOneWidget);

       final AppShimmer shimmerWidget = tester.widget<AppShimmer>(actionButtonShimmer);
      expect(shimmerWidget.height, 50);
      expect(shimmerWidget.radius, 25);
    });    testWidgets('should have a scrollable body', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

       expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}