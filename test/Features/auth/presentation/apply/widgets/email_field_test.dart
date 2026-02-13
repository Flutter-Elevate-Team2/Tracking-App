import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/email_field.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Form(
          child: EmailField(controller: controller),
        ),
      ),
    );
  }

  testWidgets('EmailField should allow typing and show text', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final emailFieldFinder = find.byKey(const Key('email_field_input'));

    expect(emailFieldFinder, findsOneWidget);

    await tester.enterText(emailFieldFinder, 'test@example.com');

    expect(controller.text, 'test@example.com');
  });

  testWidgets('Should show validation error for invalid email', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final emailFieldFinder = find.byKey(const Key('email_field_input'));

    await tester.enterText(emailFieldFinder, 'invalid-email');

  final FormFieldState<String> state = tester.state(find.byType(TextFormField));
    state.validate();

    await tester.pump();

    expect(find.textContaining('invalid'), findsOneWidget);
  });
}