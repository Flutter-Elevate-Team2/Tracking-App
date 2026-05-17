import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/screens/edit_profile_screen.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/edit_profile_form_screen.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/edit_profile_screen_body.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

// Manual Mocks
class MockEditProfileViewModel extends MockCubit<EditProfileStates>
    implements EditProfileViewModel {}

class MockSessionController extends Mock implements SessionController {
  @override
  DriverEntity? get user => super.noSuchMethod(
    Invocation.getter(#user),
    returnValue: DriverEntity(
      id: "1",
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phone: '1234567890',
      gender: 'male',
      photo: 'https://example.com/photo.jpg',
      role: 'driver',
      country: 'EG',
      vehicleType: 'car',
      vehicleNumber: '123',
      vehicleLicense: 'LIC123',
      nid: '12345678901234',
      nidImg: 'https://example.com/nid.jpg',
    ),
    returnValueForMissingStub: DriverEntity(
      id: "1",
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phone: '1234567890',
      gender: 'male',
      photo: 'https://example.com/photo.jpg',
      role: 'driver',
      country: 'EG',
      vehicleType: 'car',
      vehicleNumber: '123',
      vehicleLicense: 'LIC123',
      nid: '12345678901234',
      nidImg: 'https://example.com/nid.jpg',
    ),
  );
}

void main() {
  late MockEditProfileViewModel mockViewModel;
  late MockSessionController mockSessionController;
  final getIt = GetIt.instance;

  setUp(() {
    mockViewModel = MockEditProfileViewModel();
    mockSessionController = MockSessionController();

    // Setup GetIt
    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
    getIt.registerSingleton<SessionController>(mockSessionController);

    // Setup stubbing
    // Use whenListen for MockCubit
    whenListen(
      mockViewModel,
      Stream.value(EditProfileStates()),
      initialState: EditProfileStates(),
    );

    // We don't need to stub 'user' here because our manual mock handles it by default via noSuchMethod or hardcoded if needed
    // However, Mockito's 'when' works if we use 'Mock' class correctly.
    // Since MockSessionController extends Mock, we can use when()
    when(mockSessionController.user).thenReturn(
      DriverEntity(
        id: "1",
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        phone: '1234567890',
        gender: 'male',
        photo: 'https://example.com/photo.jpg',
        role: 'driver',
        country: 'EG',
        vehicleType: 'car',
        vehicleNumber: '123',
        vehicleLicense: 'LIC123',
        nid: '12345678901234',
        nidImg: 'https://example.com/nid.jpg',
      ),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<EditProfileViewModel>(
        create: (_) => mockViewModel,
        child: const Scaffold(body: EditProfileScreenBody()),
      ),
    );
  }

  group('EditProfileScreenBody', () {
    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreenBody), findsOneWidget);
      expect(find.byType(EditProfileForm), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('EditProfileScreen wrapper should render correctly', (
      tester,
    ) async {
      // We create a widget that provides necessary dependencies for Body
      // AND we need to ensure EditProfileScreen works
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<EditProfileViewModel>(create: (_) => mockViewModel),
              // We might need ProfileViewModel if it's accessed in build, but likely only on interaction
              // Let's try without first
            ],
            child: const EditProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
      expect(find.text('Edit profile'), findsOneWidget);
    });
  });
}
