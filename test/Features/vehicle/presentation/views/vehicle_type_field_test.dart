import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_events.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_states.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_view_model.dart';
import 'package:tracking_app/Features/vehicle/presentation/views/vehicle_type_field.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

@GenerateMocks([VehicleViewModel])
import 'vehicle_type_field_test.mocks.dart';

void main() {
  late MockVehicleViewModel mockViewModel;

  final tVehicles = [
    VehicleEntity(id: "1", type: "Car", image: ""),
    VehicleEntity(
      id: "2",
      type: "Truck",
      image: "https://example.com/truck.png",
    ),
  ];

  setUp(() async {
    mockViewModel = MockVehicleViewModel();
    when(mockViewModel.close()).thenAnswer((_) async => {});

    await getIt.reset();
    getIt.registerFactory<VehicleViewModel>(() => mockViewModel);
  });

  Widget createWidgetUnderTest({Function(VehicleEntity?)? onChanged}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
      home: Scaffold(body: VehicleTypeField(onChanged: onChanged)),
    );
  }

  group('VehicleTypeField Tests', () {
    testWidgets(
      'Should call onChanged and update ViewModel when a vehicle is selected',
      (tester) async {
        final state = VehicleStates(
          vehiclesState: BaseState<List<VehicleEntity>>(data: tVehicles),
          selectedVehicle: null,
        );

        when(mockViewModel.state).thenReturn(state);
        when(mockViewModel.stream).thenAnswer((_) => Stream.value(state));

        VehicleEntity? selectedFromCallback;

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            createWidgetUnderTest(
              onChanged: (vehicle) => selectedFromCallback = vehicle,
            ),
          );
          await tester.pump();

          final dropdown = find.byKey(const Key("vehicleTypeDropdown"));
          await tester.tap(dropdown);
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));

          expect(find.byKey(const Key("vehicleIcon_1")), findsOneWidget);
          expect(find.byKey(const Key("vehicleImage_2")), findsOneWidget);

          final truckItem = find.text('Truck').last;
          await tester.tap(truckItem);
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));

          verify(mockViewModel.doIntent(any)).called(greaterThanOrEqualTo(1));
          expect(selectedFromCallback?.id, "2");
        });
      },
    );

    testWidgets(
      'Should display error message when vehiclesState has an error',
      (tester) async {
        const errorMsg = "Failed to load vehicles";
        final errorState = VehicleStates(
          vehiclesState: BaseState<List<VehicleEntity>>(errorMessage: errorMsg),
        );

        when(mockViewModel.state).thenReturn(errorState);
        when(mockViewModel.stream).thenAnswer((_) => Stream.value(errorState));

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.text(errorMsg), findsOneWidget);
      },
    );

    testWidgets('Should initialize with GetAllVehiclesEvent on create', (
      tester,
    ) async {
      final state = VehicleStates(
        vehiclesState: BaseState<List<VehicleEntity>>(data: []),
      );
      when(mockViewModel.state).thenReturn(state);
      when(mockViewModel.stream).thenAnswer((_) => Stream.value(state));

      await tester.pumpWidget(createWidgetUnderTest());

      verify(
        mockViewModel.doIntent(argThat(isA<GetAllVehiclesEvent>())),
      ).called(1);
    });
  });
}
