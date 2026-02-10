import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/screens/profile_screen.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

import 'profile_screen_test.mocks.dart';

@GenerateMocks([ProfileViewModel])
void main() {
  late MockProfileViewModel mockViewModel;
  late StreamController<ProfileStates> streamController;

  setUp(() {
    mockViewModel = MockProfileViewModel();
    streamController = StreamController<ProfileStates>.broadcast();

    // Configure getIt to return our mock ViewModel
    getIt.reset();
    getIt.registerFactory<ProfileViewModel>(() => mockViewModel);

    // Default mock behavior
    when(mockViewModel.stream).thenAnswer((_) => streamController.stream);
    when(mockViewModel.state).thenReturn(const ProfileStates());
    when(mockViewModel.close()).thenAnswer((_) async {
      return null;
    });
    // Stub doIntent to prevent errors when called
    when(mockViewModel.doIntent(any)).thenReturn(null);
  });

  tearDown(() {
    streamController.close();
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const ProfileScreen(),
    );
  }

  testWidgets('ProfileScreen shows shimmer when loading', (
    WidgetTester tester,
  ) async {
    // Arrange
    final loadingState = ProfileStates(
      profileState: BaseState(isLoading: true),
    );
    when(mockViewModel.state).thenReturn(loadingState);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    streamController.add(loadingState);
    await tester.pump();

    // Assert
    expect(find.byType(AppShimmer), findsWidgets);
  });

  testWidgets('ProfileScreen shows error message when error occurs', (
    WidgetTester tester,
  ) async {
    // Arrange
    const errorMessage = 'Something went wrong';
    final errorState = ProfileStates(
      profileState: BaseState(isLoading: false, errorMessage: errorMessage),
    );
    when(mockViewModel.state).thenReturn(errorState);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    streamController.add(errorState);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('ProfileScreen displays user and vehicle data when successful', (
    WidgetTester tester,
  ) async {
    // Arrange
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
      vehicleNumber: 'UP16DL0007',
      vehicleLicense: 'XYZ',
      nid: '123',
      nidImg: '',
    );

    final successState = ProfileStates(
      profileState: BaseState(isLoading: false, data: driver),
    );
    when(mockViewModel.state).thenReturn(successState);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    streamController.add(successState);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
    // We expect "Vehicle info" literal or localized string.
    // Assuming default locale is English (first in list usually).
    expect(find.text('Vehicle info'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('UP16DL0007'), findsOneWidget);
  });
}
