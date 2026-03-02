import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_form.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/reset_password_widgets/reset_password_screen_body.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/shared/custom_text_section.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'reset_password_form_test.mocks.dart';

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

  Widget createWidgetUnderTest({String? email}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: ResetPasswordScreenBody(userEmail: email),
        ),
      ),
    );
  }

  group('ResetPasswordScreenBody Tests', () {
    testWidgets('1. Should render TextSection and ResetPasswordForm', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextSection), findsOneWidget);
      expect(find.byType(ResetPasswordForm), findsOneWidget);
    });

    testWidgets('2. Should pass userEmail correctly to ResetPasswordForm', (
      tester,
    ) async {
      const testEmail = 'user@example.com';
      await tester.pumpWidget(createWidgetUnderTest(email: testEmail));

      final formWidget = tester.widget<ResetPasswordForm>(
        find.byType(ResetPasswordForm),
      );

      expect(formWidget.userEmail, testEmail);
    });

    testWidgets('3. Should have correct padding and structure', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final paddingFinder = find.byType(Padding).first;
      final Padding paddingWidget = tester.widget(paddingFinder);
      expect(paddingWidget.padding, const EdgeInsets.symmetric(horizontal: 16));

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('4. Should display localized strings in TextSection', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Text), findsWidgets);
    });
  });
}
