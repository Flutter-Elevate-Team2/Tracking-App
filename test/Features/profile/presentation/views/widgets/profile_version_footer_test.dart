import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_version_footer.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  testWidgets('ProfileVersionFooter renders version text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const Scaffold(body: ProfileVersionFooter()),
      ),
    );

    await tester.pumpAndSettle();

    // Should display version text
    expect(find.byType(Text), findsOneWidget);
  });
}
