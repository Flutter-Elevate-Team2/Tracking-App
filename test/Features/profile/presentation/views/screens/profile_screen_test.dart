import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/profile_screen.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/l10n/view_model/language_cubit.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

import 'profile_screen_test.mocks.dart';

@GenerateMocks([ProfileViewModel])
void main() {
  late MockProfileViewModel mockViewModel;
  late StreamController<ProfileStates> streamController;
  late LanguageCubit languageCubit;

  setUpAll(() async {
    // Must register SharedPreferences before LanguageCubit is constructed
    // because LanguageCubit calls getIt<SharedPreferences>() in its constructor.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    GetIt.instance.allowReassignment = true;
    GetIt.instance.registerSingleton<SharedPreferences>(prefs);
  });

  setUp(() {
    GetIt.instance.allowReassignment = true;

    mockViewModel = MockProfileViewModel();
    streamController = StreamController<ProfileStates>.broadcast();
    // Now safe to create: SharedPreferences is already in GetIt from setUpAll
    languageCubit = LanguageCubit();

    GetIt.instance.registerSingleton<ProfileViewModel>(mockViewModel);

    // Stubbing
    when(mockViewModel.close()).thenAnswer((_) async {});
    when(mockViewModel.isClosed).thenReturn(false);
    when(mockViewModel.stream).thenAnswer((_) => streamController.stream);
    when(mockViewModel.state).thenReturn(const ProfileStates());
    when(mockViewModel.doIntent(any)).thenAnswer((_) async {});
  });

  tearDown(() async {
    await streamController.close();
    languageCubit.close();
  });

  tearDownAll(() async {
    await GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileViewModel>.value(value: mockViewModel),
          BlocProvider<LanguageCubit>.value(value: languageCubit),
        ],
        child: const ProfileScreen(),
      ),
    );
  }

  testWidgets('ProfileScreen shows shimmer when loading', (
    WidgetTester tester,
  ) async {
    final loadingState = ProfileStates(
      profileState: BaseState(isLoading: true),
    );

    when(mockViewModel.state).thenReturn(loadingState);

    await tester.pumpWidget(createWidgetUnderTest());

    streamController.add(loadingState);
    await tester.pump();

    expect(find.byType(AppShimmer), findsWidgets);
  });

  testWidgets('ProfileScreen shows error message when error occurs', (
    WidgetTester tester,
  ) async {
    const errorMessage = 'Something went wrong';
    final errorState = ProfileStates(
      profileState: BaseState(isLoading: false, errorMessage: errorMessage),
    );

    when(mockViewModel.state).thenReturn(errorState);

    await tester.pumpWidget(createWidgetUnderTest());

    streamController.add(errorState);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('ProfileScreen displays user and vehicle data when successful', (
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
      vehicleNumber: 'UP16DL0007',
      vehicleLicense: 'XYZ',
      nid: '123',
      nidImg: '',
    );

    final successState = ProfileStates(
      profileState: BaseState(isLoading: false, data: driver),
    );

    when(mockViewModel.state).thenReturn(successState);

    await tester.pumpWidget(createWidgetUnderTest());

    streamController.add(successState);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
    expect(find.text('Bike'), findsOneWidget);
    expect(find.text('UP16DL0007'), findsOneWidget);
  });
}
