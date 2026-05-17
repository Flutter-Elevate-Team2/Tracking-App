import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/edit_profile_form_screen.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';

@GenerateMocks([EditProfileUseCase, UploadPhotoUseCase, SessionController])
import 'edit_profile_form_widget_test.mocks.dart';

class TestEditProfileViewModel extends EditProfileViewModel {
  TestEditProfileViewModel({
    required super.editProfileUseCase,
    required super.uploadPhotoUseCase,
  });

  void emitState(EditProfileStates state) => emit(state);
}

final _testUser = DriverEntity(
  id: '1',
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@test.com',
  phone: '+201234567890',
  photo: '',
  role: 'driver',
  gender: 'male',
  country: 'Egypt',
  vehicleType: 'car',
  vehicleNumber: 'ABC123',
  vehicleLicense: 'license.jpg',
  nid: '12345',
  nidImg: 'nid.jpg',
);

late MockSessionController _mockSessionController;
late MockEditProfileUseCase _mockEditProfileUseCase;
late MockUploadPhotoUseCase _mockUploadPhotoUseCase;

Widget _pumpWidgetWithProviders({required TestEditProfileViewModel viewModel}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider<EditProfileViewModel>.value(
          value: viewModel,
          child: const EditProfileForm(),
        ),
      ),
    ),
  );
}

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    _mockSessionController = MockSessionController();
    _mockEditProfileUseCase = MockEditProfileUseCase();
    _mockUploadPhotoUseCase = MockUploadPhotoUseCase();

    when(_mockSessionController.user).thenReturn(_testUser);

    provideDummy<BaseResponse<DriverEntity>>(ErrorResponse(errorMessage: ''));
    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: ''));

    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
    getIt.registerSingleton<SessionController>(_mockSessionController);
  });

  tearDown(() {
    if (getIt.isRegistered<SessionController>()) {
      getIt.unregister<SessionController>();
    }
  });

  TestEditProfileViewModel createViewModel() {
    return TestEditProfileViewModel(
      editProfileUseCase: _mockEditProfileUseCase,
      uploadPhotoUseCase: _mockUploadPhotoUseCase,
    );
  }

  group('EditProfileForm - Rendering', () {
    testWidgets('renders all text fields with correct labels', (tester) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      viewModel.close();
    });

    testWidgets('renders Update button', (tester) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('Update'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      viewModel.close();
    });

    testWidgets('renders Change button for password field', (tester) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('Change'), findsOneWidget);

      viewModel.close();
    });

    testWidgets('renders Gender selection section', (tester) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);

      viewModel.close();
    });

    testWidgets('pre-fills text fields with user data from SessionController', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('john@test.com'), findsOneWidget);
      expect(find.text('+201234567890'), findsOneWidget);

      viewModel.close();
    });
  });

  group('EditProfileForm - Button State', () {
    testWidgets('Update button is disabled when no changes are made', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      viewModel.close();
    });

    testWidgets('Update button is enabled when user modifies a field', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      final firstNameField = find.widgetWithText(TextFormField, 'John');
      await tester.enterText(firstNameField, 'Jane');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      viewModel.close();
    });

    testWidgets('Update button is disabled when a field is cleared to empty', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      final firstNameField = find.widgetWithText(TextFormField, 'John');
      await tester.enterText(firstNameField, '');
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      viewModel.close();
    });

    testWidgets(
      'Update button is disabled when field is changed back to original',
      (tester) async {
        final viewModel = createViewModel();
        await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
        await tester.pumpAndSettle();

        final firstNameField = find.widgetWithText(TextFormField, 'John');
        await tester.enterText(firstNameField, 'Jane');
        await tester.pump();

        final enabledButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(enabledButton.onPressed, isNotNull);

        final changedField = find.widgetWithText(TextFormField, 'Jane');
        await tester.enterText(changedField, 'John');
        await tester.pump();

        final disabledButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(disabledButton.onPressed, isNull);

        viewModel.close();
      },
    );
  });

  group('EditProfileForm - Loading State', () {
    testWidgets(
      'shows CircularProgressIndicator when editProfileState is loading',
      (tester) async {
        final viewModel = createViewModel();
        await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
        await tester.pumpAndSettle();

        viewModel.emitState(
          const EditProfileStates().copyWith(
            editProfileState: BaseState(isLoading: true),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsWidgets);

        viewModel.close();
      },
    );

    testWidgets('shows Update text when not loading', (tester) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      expect(find.text('Update'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      viewModel.close();
    });
  });

  group('EditProfileForm - Success State', () {
    testWidgets('shows success SnackBar when profile update succeeds', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      final updatedUser = DriverEntity(
        id: '1',
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'john@test.com',
        phone: '+201234567890',
        photo: '',
        role: 'driver',
        gender: 'male',
        country: 'Egypt',
        vehicleType: 'car',
        vehicleNumber: 'ABC123',
        vehicleLicense: 'license.jpg',
        nid: '12345',
        nidImg: 'nid.jpg',
      );

      viewModel.emitState(
        const EditProfileStates().copyWith(
          editProfileState: BaseState(isLoading: true),
        ),
      );
      await tester.pump();

      viewModel.emitState(
        const EditProfileStates().copyWith(
          editProfileState: BaseState(isLoading: false, data: updatedUser),
        ),
      );
      await tester.pump();

      expect(find.text('Profile updated successfully!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      viewModel.close();
    });

    testWidgets('shows success SnackBar when photo upload succeeds', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      viewModel.emitState(
        const EditProfileStates().copyWith(
          uploadPhotoState: BaseState(isLoading: true),
        ),
      );
      await tester.pump();

      viewModel.emitState(
        const EditProfileStates().copyWith(
          uploadPhotoState: BaseState(
            isLoading: false,
            data: 'https://new-url.com',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Photo uploaded successfully!'), findsOneWidget);

      viewModel.close();
    });
  });

  group('EditProfileForm - Error State', () {
    testWidgets('shows error SnackBar when profile update fails', (
      tester,
    ) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      viewModel.emitState(
        const EditProfileStates().copyWith(
          editProfileState: BaseState(isLoading: true),
        ),
      );
      await tester.pump();

      viewModel.emitState(
        const EditProfileStates().copyWith(
          editProfileState: BaseState(
            isLoading: false,
            errorMessage: 'Server error',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Server error'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      viewModel.close();
    });

    testWidgets('shows error SnackBar when photo upload fails', (tester) async {
      final viewModel = createViewModel();
      await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
      await tester.pumpAndSettle();

      viewModel.emitState(
        const EditProfileStates().copyWith(
          uploadPhotoState: BaseState(isLoading: true),
        ),
      );
      await tester.pump();

      viewModel.emitState(
        const EditProfileStates().copyWith(
          uploadPhotoState: BaseState(
            isLoading: false,
            errorMessage: 'Upload failed',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Upload failed'), findsOneWidget);

      viewModel.close();
    });
  });

  group('EditProfileForm - No User', () {
    testWidgets(
      'renders with empty fields when SessionController has no user',
      (tester) async {
        when(_mockSessionController.user).thenReturn(null);

        final viewModel = createViewModel();
        await tester.pumpWidget(_pumpWidgetWithProviders(viewModel: viewModel));
        await tester.pumpAndSettle();

        expect(find.text('First Name'), findsOneWidget);
        expect(find.text('Update'), findsOneWidget);

        viewModel.close();
      },
    );
  });
}
