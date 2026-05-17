import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_vehicle_card.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

void main() {
  final driver = DriverEntity(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '1234567890',
    photo: '',
    role: 'driver',
    gender: 'Male',
    country: 'US',
    vehicleType: 'Car',
    vehicleNumber: 'ABC-123',
    vehicleLicense: '',
    nid: '',
    nidImg: '',
  );

  testWidgets('ProfileVehicleCard displays vehicle information correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ProfileVehicleCard(driver: driver, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Car'), findsOneWidget);
    expect(find.text('ABC-123'), findsOneWidget);
  });

  testWidgets('ProfileVehicleCard triggers onTap callback when tapped', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ProfileVehicleCard(
            driver: driver,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ProfileVehicleCard));
    expect(tapped, isTrue);
  });
}
