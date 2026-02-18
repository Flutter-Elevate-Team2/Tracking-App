import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/profile_screen.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

import 'profile_screen_test.mocks.dart';

@GenerateMocks([ProfileViewModel])
void main() {
  late MockProfileViewModel mockViewModel;
  late StreamController<ProfileStates> streamController;

  setUp(() {
    // 1. FIX: Don't use reset(). It clears the container aggressively causing crashes
    // if the previous widget tree tries to rebuild during teardown.
    // Instead, allow reassigning (overwriting) the singleton.
    GetIt.instance.allowReassignment = true;

    mockViewModel = MockProfileViewModel();
    streamController = StreamController<ProfileStates>.broadcast();

    // This will now overwrite the previous mock without clearing the whole container
    GetIt.instance.registerSingleton<ProfileViewModel>(mockViewModel);

    // Stubbing
    when(mockViewModel.close()).thenAnswer((_) async {});
    when(mockViewModel.isClosed).thenReturn(false);
    when(mockViewModel.stream).thenAnswer((_) => streamController.stream);

    // IMPORTANT: Stub the state getter to return default initially
    when(mockViewModel.state).thenReturn(const ProfileStates());

    when(mockViewModel.doIntent(any)).thenAnswer((_) async {});
  });

  tearDown(() async {
    await streamController.close();
    // No need to reset GetIt here either.
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: BlocProvider<ProfileViewModel>.value(
        value: mockViewModel,
        child: const ProfileScreen(),
      ),
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

    // Trigger the stream listener
    streamController.add(loadingState);
    await tester.pump();

    // Assert
    expect(find.byType(AppShimmer), findsWidgets);

    // Cleanup
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('ProfileScreen shows error message when error occurs', (
    WidgetTester tester,
  ) async {
    // Arrange
    const errorMessage = 'Something went wrong';
    final errorState = ProfileStates(
      profileState: BaseState(isLoading: false, errorMessage: errorMessage),
    );

    // Setup Mock to return error state immediately (for initial build)
    when(mockViewModel.state).thenReturn(errorState);

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Also add to stream to trigger any BlocListeners
    streamController.add(errorState);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Assert
    expect(find.text(errorMessage), findsOneWidget);

    // Cleanup
    await tester.pumpWidget(const SizedBox());
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
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Assert
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('UP16DL0007'), findsOneWidget);

    // Cleanup
    await tester.pumpWidget(const SizedBox());
  });
}
