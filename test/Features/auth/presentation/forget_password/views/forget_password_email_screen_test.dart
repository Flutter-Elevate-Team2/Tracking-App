import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/views/forget_password_email_screen.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/widgets/forget_password_widgets/forget_password_email_screen_body.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/presentation/forget_password/view_model/forget_password_state.dart';

import '../widgets/forget_password_widgets/email_form_section_test.mocks.dart';

void main() {
  late MockForgetPasswordViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockForgetPasswordViewModel();
    when(mockViewModel.state).thenReturn(ForgetPasswordState());
    when(
      mockViewModel.stream,
    ).thenAnswer((_) => Stream.value(ForgetPasswordState()));
  });

  void setScreenSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1500, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ForgetPasswordViewModel>.value(
        value: mockViewModel,
        child: ForgetPasswordEmailScreen(onNextPage: () {}),
      ),
    );
  }

  group('ForgetPasswordEmailScreen Tests', () {
    testWidgets('1. Should render AppBar with correct title', (tester) async {
      setScreenSize(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(of: find.byType(AppBar), matching: find.byType(Text)),
        findsWidgets,
      );
    });

    testWidgets('2. Should pop navigator when back button is pressed', (
      tester,
    ) async {
      setScreenSize(tester);

      await tester.pumpWidget(
        BlocProvider<ForgetPasswordViewModel>.value(
          value: mockViewModel,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ForgetPasswordEmailScreen(onNextPage: () {}),
                      ),
                    );
                  },
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();
      expect(find.byType(ForgetPasswordEmailScreen), findsOneWidget);

      final backButton = find.byIcon(Icons.arrow_back_ios);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(ForgetPasswordEmailScreen), findsNothing);
    });

    testWidgets('3. Should contain ForgetPasswordEmailScreenBody', (
      tester,
    ) async {
      setScreenSize(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ForgetPasswordEmailScreenBody), findsOneWidget);
    });
  });
}
