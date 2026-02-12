import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/edit_vehicle_screen.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/custom_button.dart';

import 'edit_vehicle_screen_test.mocks.dart';

@GenerateMocks([ProfileViewModel, SessionController])
void main() {
  late MockProfileViewModel mockViewModel;
  late MockSessionController mockSessionController;
  late StreamController<ProfileStates> streamController;

  setUp(() {
    GetIt.instance.allowReassignment = true;
    mockViewModel = MockProfileViewModel();
    mockSessionController = MockSessionController();
    streamController = StreamController<ProfileStates>.broadcast();

    GetIt.instance.registerSingleton<ProfileViewModel>(mockViewModel);
    GetIt.instance.registerSingleton<SessionController>(mockSessionController);

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
      vehicleType: 'v1',
      vehicleNumber: '12345',
      vehicleLicense: 'XYZ',
      nid: '123',
      nidImg: '',
    );

    when(mockSessionController.user).thenReturn(driver);
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
    await tester.pumpAndSettle();

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets(
    'EditVehicleScreen calls doIntent when fields are valid and Update is pressed',
    (WidgetTester tester) async {
      final vehicles = [VehicleEntity(id: 'v1', type: 'Bike', image: '')];
      final successState = ProfileStates(
        vehiclesState: BaseState(isLoading: false, data: vehicles),
      );

      when(mockViewModel.state).thenReturn(successState);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Vehicle number is pre-filled from mock driver

      // Tap Update
      final updateButton = find.byType(CustomButton);
      await tester.tap(updateButton);
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
      vehicleType: 'v1',
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

    expect(find.text('Profile updated successfully!'), findsOneWidget);

    // Allow pop to happen
    await tester.pumpAndSettle();
  });
}
