import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/password_row.dart';
import 'package:tracking_app/core/helpers/form_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late GlobalKey<FormState> formKey;

  setUp(() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();
  });

  Widget createWidgetUnderTest({
    bool isPasswordVisible = false,
    bool isConfirmPasswordVisible = false,
    VoidCallback? togglePassword,
    VoidCallback? toggleConfirm,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: const Locale('en'),
      home: Scaffold(
        body: Form(
          key: formKey,
          child: PasswordRow(
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            isPasswordVisible: isPasswordVisible,
            isConfirmPasswordVisible: isConfirmPasswordVisible,
            togglePasswordVisibility: togglePassword ?? () {},
            toggleConfirmPasswordVisibility: toggleConfirm ?? () {},
            formKey: formKey,
          ),
        ),
      ),
    );
  }

  testWidgets('Eye icon should appear immediately when text is entered in password field', (tester) async {    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(IconButton), findsNothing);

    await tester.enterText(find.byType(TextFormField).at(0), '123');

    await tester.pump();

    expect(find.byType(IconButton), findsAtLeast(1));
  });

  testWidgets('Should show error when passwords do not match', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField).at(0), 'Pass123');
    await tester.enterText(find.byType(TextFormField).at(1), 'Pass456');

    formKey.currentState!.validate();
    await tester.pump();

    final BuildContext context = tester.element(find.byType(PasswordRow));

    final String? expectedError = FormValidators.validateConfirmPassword(
        context,
        'Pass456',
        'Pass123'
    );

    expect(find.text(expectedError!), findsOneWidget);
  });

  testWidgets('Password fields should toggle obscureText correctly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(isPasswordVisible: false));
    TextField passwordField = tester.widget(find.byType(TextField).at(0));
    expect(passwordField.obscureText, isTrue);

    await tester.pumpWidget(createWidgetUnderTest(isPasswordVisible: true));
    passwordField = tester.widget(find.byType(TextField).at(0));
    expect(passwordField.obscureText, isFalse);
  });
}