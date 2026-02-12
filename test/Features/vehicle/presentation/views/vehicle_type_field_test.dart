import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/presentation/views/vehicle_type_field.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  final tVehicles = [
     VehicleEntity(id: "1", type: "Car", image: ""),
     VehicleEntity(id: "2", type: "Truck", image: "https://example.com/truck.png"),
  ];

  testWidgets('VehicleTypeField handles selection and images without errors', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: VehicleTypeField(
              vehicles: tVehicles,
              selectedVehicleId: null,
              onVehicleSelected: (id) {},
            ),
          ),
        ),
      );

      final dropdown = find.byKey(const Key("vehicleTypeDropdown"));
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOne);

      await tester.tap(find.byKey(const Key("vehicleItem_2")).last);
      await tester.pumpAndSettle();
    });
  });
}