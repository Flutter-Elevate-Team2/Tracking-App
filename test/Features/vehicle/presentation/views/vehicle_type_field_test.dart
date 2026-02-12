import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_view_model.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_states.dart';
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
    VehicleEntity(id: "2", type: "Truck", image: "https://example.com/truck.png"),
  ];

  setUp(() async {
    mockViewModel = MockVehicleViewModel();

    when(mockViewModel.close()).thenAnswer((_) async => {});

    await getIt.reset();
    getIt.registerFactory<VehicleViewModel>(() => mockViewModel);
  });

  testWidgets('VehicleTypeField handles selection and images without errors', (tester) async {
    final initialState = VehicleStates(
      vehiclesState: BaseState<List<VehicleEntity>>(data: tVehicles),
      selectedVehicle: null,
    );

    when(mockViewModel.state).thenReturn(initialState);
    when(mockViewModel.stream).thenAnswer((_) => Stream.value(initialState));

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: VehicleTypeField()),
        ),
      );

      await tester.pump();

      final dropdown = find.byKey(const Key("vehicleTypeDropdown"));
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key("vehicleIcon_1")), findsOneWidget);
      expect(find.byKey(const Key("vehicleImage_2")), findsOneWidget);

      final truckItem = find.text('Truck').last;
      await tester.tap(truckItem, warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(mockViewModel.doIntent(any)).called(greaterThanOrEqualTo(1));
    });
  });
}