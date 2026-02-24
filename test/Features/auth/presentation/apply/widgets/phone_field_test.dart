import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/phone_field.dart';
import 'package:tracking_app/core/extension/context_extension.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';
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
          child: PhoneField(controller: controller),
        ),
      ),
    );
  }

  testWidgets('PhoneField should render with correct labels and hints', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final BuildContext context = tester.element(find.byType(PhoneField));
    expect(find.text(context.l10n.phoneLabel), findsOneWidget);
    expect(find.text(context.l10n.phoneHint), findsOneWidget);
  });

  testWidgets('Should update controller when typing', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final phoneField = find.byType(TextFormField);
    await tester.enterText(phoneField, '01234567890');

    expect(controller.text, '01234567890');
  });

  testWidgets('Should show error message when phone number is invalid', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField), '123');

    final FormFieldState<String> state = tester.state(find.byType(TextFormField));
    state.validate();
    await tester.pump();

    final BuildContext context = tester.element(find.byType(PhoneField));
    final String expectedError = FormValidators.validatePhone(context, '123')!;

    expect(find.text(expectedError), findsOneWidget);
  });

  testWidgets('Keyboard type should be phone', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final TextField textField = tester.widget(find.byType(TextField));

    expect(textField.keyboardType, TextInputType.phone);
  });
}