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
    // استخدمنا mockNetworkImagesFor للتعامل مع صور الشبكة في التست
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: VehiclesDropDownList(
              // هنا كان الخطأ، قمنا باستدعاء الكلاس مباشرة
              vehicles: tVehicles,
              selectedVehicleId: null,
              onVehicleSelected: (id) {},
            ),
          ),
        ),
      );

      // 1. التأكد من وجود الـ Dropdown
      final dropdown = find.byKey(const Key("vehicleTypeDropdown"));
      expect(dropdown, findsOneWidget);

      // 2. فتح القائمة
      await tester.tap(dropdown);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // 3. التأكد من وجود الصورة (المركبة الثانية لها رابط صورة)
      // بما أن الـ Dropdown يعرض العناصر في القائمة المنسدلة، سنجد صورة واحدة
      expect(find.byType(Image), findsOneWidget);

      // 4. اختيار العنصر الثاني
      // استخدمنا .last لأن الـ DropdownMenuItem قد يتكرر في الـ Overlay الخاص بـ Flutter
      final item2 = find.byKey(const Key("vehicleItem_2")).last;
      await tester.tap(item2);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });
  });
}
