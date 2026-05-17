import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/home/presentation/views/widgets/custom_button_nav_bar.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createWidgetUnderTest({
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        bottomNavigationBar: CustomButtonNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  testWidgets('CustomButtonNavigationBar renders with correct items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      createWidgetUnderTest(currentIndex: 0, onTap: (_) {}),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.fact_check_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('CustomButtonNavigationBar calls onTap when an item is tapped', (
    WidgetTester tester,
  ) async {
    int tappedIndex = -1;
    await tester.pumpWidget(
      createWidgetUnderTest(
        currentIndex: 0,
        onTap: (index) => tappedIndex = index,
      ),
    );

    await tester.tap(find.text('Orders'));
    expect(tappedIndex, 1);

    await tester.tap(find.text('Profile'));
    expect(tappedIndex, 2);
  });
}
