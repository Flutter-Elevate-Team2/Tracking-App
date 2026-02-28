import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_form.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'reset_password_form_test.mocks.dart';

@GenerateMocks([ForgetPasswordViewModel])
void main() {
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordState> stateController;

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    stateController = StreamController<ForgetPasswordState>.broadcast();
    when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() => stateController.close());

  Widget createWidgetUnderTest({String? userEmail}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: ResetPasswordForm(userEmail: userEmail),
        ),
      ),
    );
  }

  group('ResetPasswordForm Tests', () {
    testWidgets(
      '1. Should toggle password visibility when eye icon is clicked',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        final formFieldFinder = find.byKey(const Key('newPasswordField'));

        final textFieldFinder = find.descendant(
          of: formFieldFinder,
          matching: find.byType(TextField),
        );

        final TextField textFieldBefore = tester.widget(textFieldFinder);
        expect(textFieldBefore.obscureText, isTrue);

        final eyeIcon = find.byType(IconButton).at(0);
        await tester.tap(eyeIcon);
        await tester.pump();

        final TextField textFieldAfter = tester.widget(textFieldFinder);
        expect(textFieldAfter.obscureText, isFalse);
      },
    );

    testWidgets('2. Validator should return error for invalid password', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final passwordFieldFinder = find.byKey(const Key('newPasswordField'));
      final state = tester.state<FormFieldState<String>>(passwordFieldFinder);

      state.didChange('');

      state.validate();

      await tester.pump();

      expect(state.errorText, isNotNull);
    });

    testWidgets('3. Should show error if email is null during submit', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(userEmail: null));

      await tester.enterText(
        find.byKey(const Key('newPasswordField')),
        'Password123!',
      );
      await tester.enterText(
        find.byKey(const Key('confirmPasswordField')),
        'Password123!',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('4. Should call doIntent when form is valid', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(userEmail: 'test@example.com'),
      );

      await tester.enterText(
        find.byKey(const Key('newPasswordField')),
        'Password123!',
      );
      await tester.enterText(
        find.byKey(const Key('confirmPasswordField')),
        'Password123!',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(mockViewModel.doIntent(any)).called(1);
    });

    testWidgets('5. Should show Success Dialog on success state', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      stateController.add(
        ForgetPasswordState(
          resetPasswordState: BaseState(
            isLoading: false,
            data: ResetPasswordEntity(message: 'Success', token: 'token'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      final okButton = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextButton),
      );

      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('6. Should show SnackBar when API returns an error', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      stateController.add(
        ForgetPasswordState(
          resetPasswordState: BaseState(
            isLoading: false,
            errorMessage: 'Invalid Token or Expired',
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      expect(find.text('Invalid Token or Expired'), findsOneWidget);
    });

    testWidgets('7. Should enable auto-validation when form submission fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(userEmail: 'test@test.com'),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      final formWidget = tester.widget<Form>(find.byType(Form));
      expect(formWidget.autovalidateMode, AutovalidateMode.onUserInteraction);
    });

    testWidgets('8. Should toggle confirm password visibility', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final confirmFieldFinder = find.descendant(
        of: find.byKey(const Key('confirmPasswordField')),
        matching: find.byType(TextField),
      );

      final eyeIcon = find.byType(IconButton).at(1);
      await tester.tap(eyeIcon);
      await tester.pump();

      final TextField field = tester.widget(confirmFieldFinder);
      expect(field.obscureText, isFalse);
    });

    testWidgets('9. Should show loading indicator and disable fields', (
      tester,
    ) async {
      when(mockViewModel.state).thenReturn(
        ForgetPasswordState(resetPasswordState: BaseState(isLoading: true)),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const Key('newPasswordField')),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.enabled, isFalse);
    });
  });
}
