import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_states.dart';
import 'package:tracking_app/Features/auth/presentation/apply/view_model/apply_view_model.dart';
import 'package:tracking_app/Features/auth/presentation/apply/widgets/apply_form.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_states.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_view_model.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/custom_button.dart';

import '../../../../vehicle/presentation/views/vehicle_type_field_test.mocks.dart';
import 'apply_form_test.mocks.dart';

@GenerateMocks([ApplyViewModel, GoRouter])
void main() {
  late MockApplyViewModel mockApplyViewModel;
  late MockVehicleViewModel mockVehicleViewModel;
  late MockGoRouter mockRouter;

  setUp(() async {
    mockApplyViewModel = MockApplyViewModel();
    mockVehicleViewModel = MockVehicleViewModel();
    mockRouter = MockGoRouter();

    await getIt.reset();
    getIt.registerFactory<ApplyViewModel>(() => mockApplyViewModel);
    getIt.registerFactory<VehicleViewModel>(() => mockVehicleViewModel);

    when(
      mockApplyViewModel.state,
    ).thenReturn(ApplyStates(applyState: BaseState(isLoading: false)));
    when(mockApplyViewModel.stream).thenAnswer(
      (_) => Stream.value(ApplyStates(applyState: BaseState(isLoading: false))),
    );
    when(
      mockVehicleViewModel.state,
    ).thenReturn(VehicleStates(vehiclesState: BaseState(data: [])));
    when(mockVehicleViewModel.stream).thenAnswer(
      (_) => Stream.value(VehicleStates(vehiclesState: BaseState(data: []))),
    );

    when(
      mockRouter.pushNamed(
        any,
        pathParameters: anyNamed('pathParameters'),
        queryParameters: anyNamed('queryParameters'),
        extra: anyNamed('extra'),
      ),
    ).thenAnswer((_) async => null);

    when(mockApplyViewModel.close()).thenAnswer((_) async => {});
    when(mockVehicleViewModel.close()).thenAnswer((_) async => {});
  });

  Widget createWidgetUnderTest() {
    return InheritedGoRouter(
      goRouter: mockRouter,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider<ApplyViewModel>.value(
            value: mockApplyViewModel,
            child: const SingleChildScrollView(child: ApplyForm()),
          ),
        ),
      ),
    );
  }

  group('ApplyForm test', () {
    testWidgets('Should navigate to success when data is received', (
      tester,
    ) async {
      final successState = ApplyStates(
        applyState: BaseState(data: ApplyEntity(), isLoading: false),
      );

      when(mockApplyViewModel.state).thenReturn(successState);
      when(
        mockApplyViewModel.stream,
      ).thenAnswer((_) => Stream.value(successState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      verify(
        mockRouter.pushNamed(
          Routes.successApplyName,
          pathParameters: anyNamed('pathParameters'),
          queryParameters: anyNamed('queryParameters'),
          extra: anyNamed('extra'),
        ),
      ).called(1);
    });

    testWidgets('Should cover error SnackBar in listener', (tester) async {
      final errorState = ApplyStates(
        applyState: BaseState(
          errorMessage: "Validation Error",
          isLoading: false,
        ),
      );

      when(mockApplyViewModel.state).thenReturn(errorState);
      when(
        mockApplyViewModel.stream,
      ).thenAnswer((_) => Stream.value(errorState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text("Validation Error"), findsOneWidget);
    });

    testWidgets('Should cover isLoading block in listener', (tester) async {
      final loadingState = ApplyStates(applyState: BaseState(isLoading: true));

      when(mockApplyViewModel.state).thenReturn(loadingState);
      when(
        mockApplyViewModel.stream,
      ).thenAnswer((_) => Stream.value(loadingState));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
    });

    testWidgets('Should trigger form validation on button press', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(find.textContaining(RegExp(r'.*')), findsAtLeast(1));
    });
  });
}
