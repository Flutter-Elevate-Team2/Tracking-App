import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_states.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/apply/views/apply_screen.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_view_model.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_states.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import '../../../../vehicle/presentation/views/vehicle_type_field_test.mocks.dart';
@GenerateMocks([ApplyViewModel])
import 'apply_screen_test.mocks.dart';

void main() {
  late MockApplyViewModel mockApplyViewModel;
  late MockVehicleViewModel mockVehicleViewModel;

  setUp(() async {
    mockApplyViewModel = MockApplyViewModel();
    mockVehicleViewModel = MockVehicleViewModel();

    when(mockApplyViewModel.close()).thenAnswer((_) async => {});
    when(mockVehicleViewModel.close()).thenAnswer((_) async => {});

    when(mockApplyViewModel.state).thenReturn(ApplyStates());
    when(mockApplyViewModel.stream).thenAnswer((_) => Stream.value(ApplyStates()));

    final initialVehicleState = VehicleStates(
      vehiclesState: BaseState(data: [], isLoading: false),
      selectedVehicle: null,
    );

    when(mockVehicleViewModel.state).thenReturn(initialVehicleState);
    when(mockVehicleViewModel.stream).thenAnswer((_) => Stream.value(initialVehicleState));

    await getIt.reset();
    getIt.registerFactory<ApplyViewModel>(() => mockApplyViewModel);
    getIt.registerFactory<VehicleViewModel>(() => mockVehicleViewModel);
  });
  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ApplyScreen(),
    );
  }

  testWidgets('ApplyScreen renders and finds essential components', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(ApplyScreen), findsOneWidget);

    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
  });

  testWidgets('shows error SnackBar on ApplyStates error', (tester) async {
    // Arrange
    final errorState = ApplyStates(
      applyState: BaseState(
        isLoading: false,
        errorMessage: 'Failed to apply',
      ),
    );

    when(mockApplyViewModel.state).thenReturn(errorState);
    when(mockApplyViewModel.stream).thenAnswer((_) => Stream.value(errorState));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Assert
    expect(find.text('Failed to apply'), findsOneWidget);
  });}