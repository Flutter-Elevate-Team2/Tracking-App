import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/gender_redio_button.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/gender_selection.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  group('Gender Widgets', () {
    testWidgets('GenderRadioButton renders label and selection state', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GenderRadioButton(label: 'Male', isSelected: true),
          ),
        ),
      );

      expect(find.text('Male'), findsOneWidget);
      final radio = tester.widget<Radio<bool>>(find.byType(Radio<bool>));
      expect(radio.groupValue, isTrue);
    });

    testWidgets('GenderRadioButton calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderRadioButton(
              label: 'Female',
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Female'));
      expect(tapped, isTrue);
    });

    testWidgets('GenderSelectionSection renders correctly with selection', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Scaffold(
            body: GenderSelectionSection(selectedGender: 'male'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      // Verify there are exactly 2 radio buttons
      expect(find.byType(Radio<bool>), findsNWidgets(2));

      // Verify there are 2 GenderRadioButton widgets
      expect(find.byType(GenderRadioButton), findsNWidgets(2));
    });
  });
}
