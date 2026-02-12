import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/language_change_dialog.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  group('LanguageChangeDialog', () {
    testWidgets('renders dialog with language options', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Material(child: LanguageChangeDialog()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Change Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Arabic'), findsOneWidget);
      expect(find.text('cancel'), findsOneWidget); // lowercase 'cancel'
      expect(find.byIcon(Icons.translate_rounded), findsOneWidget);
    });

    testWidgets('shows selected language with check icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Material(child: LanguageChangeDialog()),
        ),
      );

      await tester.pumpAndSettle();

      // English should be selected by default in the widget
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
