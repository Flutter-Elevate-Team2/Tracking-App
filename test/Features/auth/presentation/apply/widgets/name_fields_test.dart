import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/name_fields.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  setUp(() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  });

  tearDown(() {
    firstNameController.dispose();
    lastNameController.dispose();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          child: NameFields(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
          ),
        ),
      ),
    );
  }

  testWidgets('Should render first and last name fields using Keys', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byKey(const Key('firstNameField')), findsOneWidget);
    expect(find.byKey(const Key('lastNameField')), findsOneWidget);
  });

  testWidgets('Should update controllers when user types', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byKey(const Key('firstNameField')), 'Ahmed');
    await tester.enterText(find.byKey(const Key('lastNameField')), 'Mohamed');

    expect(firstNameController.text, 'Ahmed');
    expect(lastNameController.text, 'Mohamed');
  });

  testWidgets('Should show validation errors when fields are empty', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();

    final secondFieldFinder = find.byKey(const Key('lastNameField'));
    await tester.ensureVisible(secondFieldFinder);

    await tester.pumpAndSettle();

    expect(find.textContaining('required'), findsNWidgets(2));
  });
}