import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/password_field.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  late TextEditingController controller;
  late bool onChangedCalled;

  setUp(() {
    controller = TextEditingController();
    onChangedCalled = false;
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PasswordField(
          controller: controller,
          onChanged: () {
            onChangedCalled = true;
          },
        ),
      ),
    );
  }

  testWidgets('renders PasswordField', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final field = find.byKey(Key('passwordField'));
    expect(field, findsOneWidget);
  });

  testWidgets('calls onChanged when text is entered', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byKey(Key('passwordField')), 'password');
    await tester.pump();

    expect(controller.text, 'password');
    expect(onChangedCalled, true);
  });

  testWidgets('toggles password visibility when suffix icon is tapped', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final suffixIcon = find.byType(IconButton);
    expect(suffixIcon, findsOneWidget);

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('passwordField')))
          .enabled,
      true,
    );

    await tester.enterText(find.byKey(const Key('passwordField')), 'password');

    await tester.tap(suffixIcon);
    await tester.pump();

    expect(find.text('password'), findsOneWidget);

    await tester.tap(suffixIcon);
    await tester.pump();

    expect(find.text('password'), findsOneWidget);
  });

  testWidgets('validator returns error for invalid password', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final field = find.byKey(Key('passwordField'));
    final state = tester.state<FormFieldState<String>>(field);

    state.didChange('');
    await tester.pump();

    expect(state.errorText, isNotNull);
  });

  testWidgets('validator returns null for valid password', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final field = find.byKey(Key('passwordField'));
    final state = tester.state<FormFieldState<String>>(field);

    state.didChange('Valid123');
    await tester.pump();

    expect(state.errorText, null);
  });
}
