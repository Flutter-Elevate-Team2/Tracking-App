import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/change_password_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/chang_password_use_case.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/change_password/change_password_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/change_password/change_password_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/reset_password_screen.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/reset_password_screen_body.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

@GenerateMocks([ChangPasswordUseCase, SessionController])
import 'reset_password_widget_test.mocks.dart';

class TestChangePasswordViewModel extends ChangePasswordViewModel {
  TestChangePasswordViewModel(
    super.changPasswordUseCase,
    super.sessionController,
  );

  void emitState(ChangePasswordStates state) => emit(state);
}

late MockChangPasswordUseCase _mockUseCase;
late MockSessionController _mockSessionController;

Widget _buildTestApp({
  required TestChangePasswordViewModel viewModel,
  bool withBackPage = false,
}) {
  if (withBackPage) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: BlocProvider<ChangePasswordViewModel>.value(
                      value: viewModel,
                      child: const ResetPasswordScreenBody(),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Go'),
          ),
        ),
      ),
    );
  }
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(
      body: BlocProvider<ChangePasswordViewModel>.value(
        value: viewModel,
        child: const ResetPasswordScreenBody(),
      ),
    ),
  );
}

void main() {
  setUp(() {
    _mockUseCase = MockChangPasswordUseCase();
    _mockSessionController = MockSessionController();

    provideDummy<BaseResponse<ChangePasswordEntity>>(
      ErrorResponse(errorMessage: ''),
    );
  });

  TestChangePasswordViewModel createViewModel() {
    return TestChangePasswordViewModel(_mockUseCase, _mockSessionController);
  }

  group('ResetPasswordScreenBody - Rendering', () {
    testWidgets('renders all password fields with correct labels', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('Current password'), findsWidgets);
      expect(find.text('New password'), findsWidgets);
      expect(find.text('Confirm password'), findsWidgets);

      viewModel.close();
    });

    testWidgets('renders Update button', (tester) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('Update'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      viewModel.close();
    });

    testWidgets('renders visibility toggle icons for all password fields', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(3));

      viewModel.close();
    });
  });

  group('ResetPasswordScreenBody - Button State', () {
    testWidgets('Update button is disabled when all fields are empty', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      viewModel.close();
    });

    testWidgets('Update button is disabled when only some fields are filled', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'OldPass1!');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      viewModel.close();
    });

    testWidgets('Update button is enabled when all fields are filled', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'OldPass1!');
      await tester.enterText(fields.at(1), 'NewPass1!');
      await tester.enterText(fields.at(2), 'NewPass1!');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      viewModel.close();
    });

    testWidgets('Update button becomes disabled when a field is cleared', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'OldPass1!');
      await tester.enterText(fields.at(1), 'NewPass1!');
      await tester.enterText(fields.at(2), 'NewPass1!');
      await tester.pump();

      final enabledButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(enabledButton.onPressed, isNotNull);

      await tester.enterText(fields.at(1), '');
      await tester.pump();

      final disabledButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(disabledButton.onPressed, isNull);

      viewModel.close();
    });
  });

  group('ResetPasswordScreenBody - Visibility Toggle', () {
    testWidgets('tapping visibility icon toggles password visibility', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(3));

      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.pump();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      viewModel.close();
    });
  });

  group('ResetPasswordScreenBody - Loading State', () {
    testWidgets('shows loading dialog when changePasswordState is loading', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_buildTestApp(viewModel: viewModel));
      await tester.pumpAndSettle();

      viewModel.emitState(
        const ChangePasswordStates().copyWith(
          changePasswordState: BaseState(isLoading: true),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      viewModel.close();
    });
  });

  group('ResetPasswordScreenBody - Success State', () {
    testWidgets('shows success SnackBar when password change succeeds', (
      tester,
    ) async {
      final viewModel = createViewModel();

      await tester.pumpWidget(
        _buildTestApp(viewModel: viewModel, withBackPage: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      viewModel.emitState(
        const ChangePasswordStates().copyWith(
          changePasswordState: BaseState(isLoading: true),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      viewModel.emitState(
        const ChangePasswordStates().copyWith(
          changePasswordState: BaseState(
            isLoading: false,
            data: const ChangePasswordEntity(
              message: 'Password changed successfully',
              token: 'new_token',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Password changed successfully'), findsOneWidget);

      viewModel.close();
    });
  });

  group('ResetPasswordScreenBody - Error State', () {
    testWidgets('shows error SnackBar when password change fails', (
      tester,
    ) async {
      final viewModel = createViewModel();

      await tester.pumpWidget(
        _buildTestApp(viewModel: viewModel, withBackPage: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      viewModel.emitState(
        const ChangePasswordStates().copyWith(
          changePasswordState: BaseState(isLoading: true),
        ),
      );
      await tester.pump();
      await tester.pump();

      viewModel.emitState(
        const ChangePasswordStates().copyWith(
          changePasswordState: BaseState(
            isLoading: false,
            errorMessage: 'Incorrect current password',
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Incorrect current password'), findsOneWidget);

      viewModel.close();
    });
  });

  group('ResetPasswordScreen Wrapper', () {
    testWidgets('renders ResetPasswordScreen correctly', (tester) async {
      final viewModel = createViewModel();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<ChangePasswordViewModel>.value(
            value: viewModel,
            child: const ResetPasswordScreen(),
          ),
        ),
      );

      expect(find.byType(ResetPasswordScreen), findsOneWidget);
      expect(
        find.text('Reset password'),
        findsOneWidget,
      ); // Assuming title from l10n
    });
  });
}
