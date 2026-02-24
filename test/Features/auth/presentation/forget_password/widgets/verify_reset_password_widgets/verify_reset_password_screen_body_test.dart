import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_event.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/otp_input_widget.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/verify_reset_password_widgets/verify_reset_password_screen_body.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import '../reset_password_widgets/reset_password_form_test.mocks.dart';

void main() {
  late MockForgetPasswordViewModel mockViewModel;
  late StreamController<ForgetPasswordState> stateController;

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    stateController = StreamController<ForgetPasswordState>.broadcast();

    when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(mockViewModel.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest({VoidCallback? onNextPage}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: VerifyResetPasswordScreenBody(
            onNextPage: onNextPage ?? () {},
            email: 'test@test.com',
          ),
        ),
      ),
    );
  }

  group('VerifyResetPasswordScreenBody Tests', () {
    testWidgets('1. Should call VerifyOtp intent when OTP is completed', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final otpWidget = tester.widget<OtpInputWidget>(
        find.byType(OtpInputWidget),
      );
      otpWidget.onCompleted('123456');

      await tester.pump();

      verify(
        mockViewModel.doIntent(
          argThat(isA<VerifyOtp>().having((e) => e.otp, 'otp', '123456')),
        ),
      ).called(1);
    });

    testWidgets(
      '2. Should show CircularProgressIndicator when verifyOtpState is loading',
      (tester) async {
        when(mockViewModel.state).thenReturn(
          ForgetPasswordState(verifyOtpState: BaseState(isLoading: true)),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      '3. Should trigger onNextPage when OTP success (Listener test)',
      (tester) async {
        bool isNextPageCalled = false;

        await tester.pumpWidget(
          createWidgetUnderTest(onNextPage: () => isNextPageCalled = true),
        );

        stateController.add(
          ForgetPasswordState(
            verifyOtpState: BaseState(
              isLoading: false,
              data: VerifyResetPasswordEntity(status: "Success Message"),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(isNextPageCalled, isTrue);
      },
    );

    testWidgets('4. Should pass error message to OtpInputWidget from state', (
      tester,
    ) async {
      const errorMsg = "Wrong Code";
      when(mockViewModel.state).thenReturn(
        ForgetPasswordState(verifyOtpState: BaseState(errorMessage: errorMsg)),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final otpWidget = tester.widget<OtpInputWidget>(
        find.byType(OtpInputWidget),
      );
      expect(otpWidget.errorText, errorMsg);
    });
  });
}
