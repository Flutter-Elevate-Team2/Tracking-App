import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/remember_me_row.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  Widget createWidget({
    required bool rememberMe,
    required Function(bool?) onChanged,
    required VoidCallback onForgotPassword,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: RememberMeRow(
          rememberMe: rememberMe,
          onChanged: onChanged,
          onForgotPassword: onForgotPassword,
        ),
      ),
    );
  }

  testWidgets('Should trigger onForgotPassword when text button is pressed', (
    tester,
  ) async {
    bool forgotPasswordCalled = false;

    await tester.pumpWidget(
      createWidget(
        rememberMe: false,
        onChanged: (_) {},
        onForgotPassword: () {
          forgotPasswordCalled = true;
        },
      ),
    );

    final forgotBtn = find.byType(TextButton);
    expect(forgotBtn, findsOneWidget);

    await tester.tap(forgotBtn);
    await tester.pump();

    expect(forgotPasswordCalled, true);
  });

  testWidgets('Should trigger onChanged when checkbox is tapped', (
    tester,
  ) async {
    bool? newValue;

    await tester.pumpWidget(
      createWidget(
        rememberMe: false,
        onChanged: (val) => newValue = val,
        onForgotPassword: () {},
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(newValue, true);
  });
}
