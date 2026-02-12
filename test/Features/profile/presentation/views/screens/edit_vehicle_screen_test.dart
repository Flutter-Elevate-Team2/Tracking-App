
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/edit_vehicle_screen.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

import 'profile_screen_test.mocks.dart';

@GenerateMocks([ProfileViewModel])
void main() {
  late MockProfileViewModel mockViewModel;
  late StreamController<ProfileStates> streamController;

  setUp(() {
    GetIt.instance.allowReassignment = true;
    mockViewModel = MockProfileViewModel();
    streamController = StreamController<ProfileStates>.broadcast();

    GetIt.instance.registerSingleton<ProfileViewModel>(mockViewModel);

    when(mockViewModel.close()).thenAnswer((_) async {});
    when(mockViewModel.isClosed).thenReturn(false);
    when(mockViewModel.stream).thenAnswer((_) => streamController.stream);
    when(mockViewModel.state).thenReturn(const ProfileStates());
    when(mockViewModel.doIntent(any)).thenAnswer((_) async {});
  });

  tearDown(() async {
    await streamController.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const EditVehicleScreen(),
    );
  }

  testWidgets('EditVehicleScreen renders all fields correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Vehicle type'), findsOneWidget);
    expect(find.text('Vehicle number'), findsOneWidget);
    expect(find.text('Vehicle license'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
  });

  testWidgets('EditVehicleScreen shows error snackbar on failure', (
    WidgetTester tester,
  ) async {
    const errorMessage = 'Failed to update profile';
    final errorState = ProfileStates(
      editVehicleState: BaseState(isLoading: false, errorMessage: errorMessage),
    );

    when(mockViewModel.state).thenReturn(errorState);

    await tester.pumpWidget(createWidgetUnderTest());

    streamController.add(errorState);
    await tester.pump(); // Start animation
    await tester.pump(
      const Duration(milliseconds: 100),
    ); // Should show snackbar

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets(
    'EditVehicleScreen calls doIntent when fields are valid and Update is pressed',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Fill vehicle number
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Vehicle number'),
        '12345',
      );

      // Select vehicle type
      await tester.tap(find.text('Vehicle type'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bike').last);
      await tester.pumpAndSettle();

      // Tap Update
      await tester.tap(find.text('Update'));
      await tester.pump();

      verify(
        mockViewModel.doIntent(argThat(isA<EditVehicleEvent>())),
      ).called(1);
    },
  );

  testWidgets('EditVehicleScreen shows success snackbar and pops on success', (
    WidgetTester tester,
  ) async {
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
      vehicleType: 'Bike',
      vehicleNumber: '12345',
      vehicleLicense: 'XYZ',
      nid: '123',
      nidImg: '',
    );

    final successState = ProfileStates(
      editVehicleState: BaseState(isLoading: false, data: driver),
    );

    when(mockViewModel.state).thenReturn(successState);

    await tester.pumpWidget(createWidgetUnderTest());

    streamController.add(successState);
    await tester.pump();

    expect(find.text('Profile updated successfully'), findsOneWidget);
  });
}
