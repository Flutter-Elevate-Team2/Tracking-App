import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_event.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_state.dart';
import 'package:tracking_app/Features/auth/presentation/login/view_model/login_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/email_field.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/login_form.dart';
import 'package:tracking_app/Features/auth/presentation/login/widgets/password_field.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'login_form_test.mocks.dart';

Widget pumpLoginForm({required LoginViewModel viewModel}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<LoginViewModel>.value(
      value: viewModel,
      child: const Scaffold(body: LoginForm()),
    ),
  );
}

Widget pumpPasswordField({required TextEditingController controller}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: PasswordField(controller: controller, onChanged: () {}),
    ),
  );
}

Widget pumpEmailField({required TextEditingController controller}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: EmailField(controller: controller, onChanged: () {}),
    ),
  );
}

@GenerateMocks([LoginViewModel])
void main() {
  late MockLoginViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockLoginViewModel();

    when(mockViewModel.state).thenReturn(const LoginState());
    when(
      mockViewModel.stream,
    ).thenAnswer((_) => Stream<LoginState>.value(const LoginState()));

    when(mockViewModel.close()).thenAnswer((_) async {});
  });

  testWidgets(
    '1. Should render all fields and keep button disabled initially',
    (tester) async {
      await tester.pumpWidget(pumpLoginForm(viewModel: mockViewModel));

      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.textContaining('Continue'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, false);
    },
  );

  testWidgets(
    '2. Entering valid data should enable button and call UserTypingEvent',
    (tester) async {
      await tester.pumpWidget(pumpLoginForm(viewModel: mockViewModel));

      await tester.pumpAndSettle();

      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'test@email.com');
      await tester.enterText(passwordField, 'Password123');

      await tester.pump();

      verify(mockViewModel.doIntent(any)).called(greaterThanOrEqualTo(2));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, true);
    },
  );

  testWidgets('3. Toggle Remember Me should call ToggleRememberMeEvent', (
    tester,
  ) async {
    await tester.pumpWidget(pumpLoginForm(viewModel: mockViewModel));

    await tester.pumpAndSettle();

    final checkbox = find.byType(Checkbox);
    await tester.tap(checkbox);
    await tester.pump();

    verify(mockViewModel.doIntent(any)).called(1);
  });

  testWidgets('4. Press login button triggers LoginButtonClickedEvent', (
    tester,
  ) async {
    await tester.pumpWidget(pumpLoginForm(viewModel: mockViewModel));

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Password123');
    await tester.pump();

    await tester.tap(find.textContaining('Continue'));
    await tester.pump();

    final captured = verify(mockViewModel.doIntent(captureAny)).captured;

    expect(captured.any((e) => e is LoginButtonClickedEvent), true);
  });

  testWidgets('5. Error state reset while typing', (tester) async {
    when(mockViewModel.state).thenReturn(
      const LoginState(
        loginState: BaseState(errorMessage: 'Invalid credentials'),
      ),
    );

    when(mockViewModel.stream).thenAnswer(
      (_) => Stream<LoginState>.value(
        const LoginState(
          loginState: BaseState(errorMessage: 'Invalid credentials'),
        ),
      ),
    );

    await tester.pumpWidget(pumpLoginForm(viewModel: mockViewModel));

    await tester.pumpAndSettle();

    final emailField = find.byType(TextFormField).at(0);
    await tester.enterText(emailField, 'abc@example.com');
    await tester.pump();

    verify(mockViewModel.doIntent(any)).called(1);
  });

  testWidgets('6. Shows loading indicator while login is in progress', (
    tester,
  ) async {
    when(
      mockViewModel.state,
    ).thenReturn(const LoginState(loginState: BaseState(isLoading: true)));

    when(mockViewModel.stream).thenAnswer(
      (_) => Stream<LoginState>.value(
        const LoginState(loginState: BaseState(isLoading: true)),
      ),
    );

    await tester.pumpWidget(pumpLoginForm(viewModel: mockViewModel));

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    '7. Press login button when form is invalid does NOT trigger LoginButtonClickedEvent',
    (tester) async {
      await tester.pumpWidget(pumpLoginForm(viewModel: mockViewModel));
      await tester.pumpAndSettle();

      final button = find.textContaining('Continue');
      await tester.tap(button);
      await tester.pump();

      verifyNever(mockViewModel.doIntent(any));
    },
  );
}
