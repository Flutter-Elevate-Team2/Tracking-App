import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart'; // تأكد من إضافة هذه المكتبة
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/presentation/views/vehicles_drop_down_list.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  final tVehicles = [
    VehicleEntity(id: "1", type: "Car", image: ""),
    VehicleEntity(
      id: "2",
      type: "Truck",
      image: "https://example.com/truck.png",
    ),
  ];

  testWidgets('VehicleDropDown handles selection and images without errors', (
    tester,
  ) async {
  await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: Scaffold(
            body: VehiclesDropDownList(
              vehicles: tVehicles,
              selectedVehicleId: null,
              onVehicleSelected: (id) {},
            ),
          ),
        ),
      );

      final dropdown = find.byKey(const Key("vehicleTypeDropdown"));
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(Image), findsOneWidget);
      final item2 = find.byKey(const Key("vehicleItem_2")).last;
      await tester.ensureVisible(item2);
      await tester.tap(item2, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
