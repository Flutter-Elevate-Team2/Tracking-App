import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_user_card.dart';

void main() {
  final driver = DriverEntity(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phone: '+1234567890',
    photo: '',
    role: 'driver',
    gender: 'Male',
    country: 'USA',
    vehicleType: 'Car',
    vehicleNumber: 'ABC-123',
    vehicleLicense: 'XYZ-456',
    nid: '123456789',
    nidImg: '',
  );

  testWidgets('ProfileUserCard displays user information correctly', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileUserCard(driver: driver, onTap: () {}),
        ),
      ),
    );

    // Assert
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john.doe@example.com'), findsOneWidget);
    expect(find.text('+1234567890'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });

  testWidgets('ProfileUserCard triggers onTap callback when tapped', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileUserCard(
            driver: driver,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ProfileUserCard));
    await tester.pump();

    // Assert
    expect(tapped, isTrue);
  });
}
