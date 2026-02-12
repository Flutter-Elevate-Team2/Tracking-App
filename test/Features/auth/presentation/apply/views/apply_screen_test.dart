import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_states.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/apply/views/apply_screen.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

class MockApplyViewModel extends MockCubit<ApplyStates>
    implements ApplyViewModel {}

void main() {
  late MockApplyViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockApplyViewModel();
    GetIt.I.registerSingleton<ApplyViewModel>(mockViewModel);
  });

  tearDown(() {
    GetIt.I.unregister<ApplyViewModel>();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ApplyScreen(),
    );
  }

  testWidgets('ApplyScreen renders correctly', (WidgetTester tester) async {
    whenListen(
      mockViewModel,
      Stream.value(ApplyStates()),
      initialState: ApplyStates(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ApplyScreen), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('show error SnackBar on Apply error', (
      WidgetTester tester,
      ) async {
    // Arrange
    whenListen(
      mockViewModel,
      Stream.fromIterable([
        ApplyStates(applyState: BaseState(isLoading: true)),
        ApplyStates(
          applyState: BaseState(
            isLoading: false,
            errorMessage: 'Apply Failed',
          ),
        ),
      ]),
      initialState: ApplyStates(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump();

    // Assert
    expect(find.text('Apply Failed'), findsOneWidget);
  });
}
