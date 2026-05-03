import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/edit_vehicle_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_driver_profile_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/get_vehicles_use_case.dart';
import 'package:tracking_app/Features/profile/domain/use_cases/logout_use_case.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_states.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/controller/session_controller.dart';

import 'profile_view_model_test.mocks.dart';

@GenerateMocks([
  GetDriverProfileUseCase,
  LogoutUseCase,
  EditVehicleUseCase,
  GetVehiclesUseCase,
  SessionController,
])
void main() {
  late ProfileViewModel viewModel;
  late MockGetDriverProfileUseCase mockGetDriverProfileUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockEditVehicleUseCase mockEditVehicleUseCase;
  late MockGetVehiclesUseCase mockGetVehiclesUseCase;
  late MockSessionController mockSessionController;

  setUp(() {
    provideDummy<BaseResponse<String>>(ErrorResponse(errorMessage: 'dummy'));
    provideDummy<BaseResponse<DriverEntity>>(
      ErrorResponse(errorMessage: 'dummy'),
    );
    provideDummy<BaseResponse<List<VehicleEntity>>>(
      ErrorResponse(errorMessage: 'dummy'),
    );

    mockGetDriverProfileUseCase = MockGetDriverProfileUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockEditVehicleUseCase = MockEditVehicleUseCase();
    mockGetVehiclesUseCase = MockGetVehiclesUseCase();
    mockSessionController = MockSessionController();
    when(mockSessionController.onLogin).thenAnswer((_) => const Stream.empty());

    viewModel = ProfileViewModel(
      mockGetDriverProfileUseCase,
      mockLogoutUseCase,
      mockEditVehicleUseCase,
      mockGetVehiclesUseCase,
      mockSessionController,
    );
  });

  group('ProfileViewModel Tests', () {
    test('initial state should be ProfileStates()', () {
      expect(viewModel.state, const ProfileStates());
    });

    group('GetVehicles Tests', () {
      final vehicles = [VehicleEntity(id: '1', type: 'Car', image: '')];

      test(
        'should emit loading then success when GetVehiclesUseCase succeeds',
        () async {
          when(
            mockGetVehiclesUseCase.call(),
          ).thenAnswer((_) async => SuccessResponse(data: vehicles));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                (state) => state.vehiclesState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                (state) =>
                    state.vehiclesState?.isLoading == false &&
                    state.vehiclesState?.data == vehicles,
              ),
            ]),
          );

          viewModel.doIntent(GetVehiclesEvent());
          await expectation;
        },
      );

      test(
        'should emit loading then error when GetVehiclesUseCase fails',
        () async {
          const errorMessage = 'Error fetching vehicles';
          when(
            mockGetVehiclesUseCase.call(),
          ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                (state) => state.vehiclesState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                (state) =>
                    state.vehiclesState?.isLoading == false &&
                    state.vehiclesState?.errorMessage == errorMessage,
              ),
            ]),
          );

          viewModel.doIntent(GetVehiclesEvent());
          await expectation;
        },
      );
    });

    group('GetDriverProfile Tests', () {
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
        vehicleNumber: '12345',
        vehicleLicense: 'XYZ',
        nid: '123',
        nidImg: '',
      );

      test(
        'should emit loading then success and save user when GetDriverProfileUseCase succeeds',
        () async {
          when(
            mockGetDriverProfileUseCase.call(),
          ).thenAnswer((_) async => SuccessResponse(data: driver));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                (state) => state.profileState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                (state) =>
                    state.profileState?.isLoading == false &&
                    state.profileState?.data == driver,
              ),
            ]),
          );

          viewModel.doIntent(GetDriverProfileEvent());
          await expectation;

          verify(mockSessionController.saveUser(driver)).called(1);
        },
      );

      test(
        'should emit loading then error when GetDriverProfileUseCase fails',
        () async {
          const errorMessage = 'Error fetching profile';
          when(
            mockGetDriverProfileUseCase.call(),
          ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                (state) => state.profileState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                (state) =>
                    state.profileState?.isLoading == false &&
                    state.profileState?.errorMessage == errorMessage,
              ),
            ]),
          );

          viewModel.doIntent(GetDriverProfileEvent());
          await expectation;
        },
      );
    });

    group('EditVehicle Tests', () {
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
        vehicleNumber: '54321',
        vehicleLicense: 'ABC',
        nid: '123',
        nidImg: '',
      );

      test(
        'should emit loading then success and update session when EditVehicleUseCase succeeds',
        () async {
          when(
            mockEditVehicleUseCase.call(
              vehicleType: anyNamed('vehicleType'),
              vehicleNumber: anyNamed('vehicleNumber'),
              vehicleLicense: anyNamed('vehicleLicense'),
            ),
          ).thenAnswer((_) async => SuccessResponse(data: driver));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                (state) => state.editVehicleState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                (state) =>
                    state.editVehicleState?.isLoading == false &&
                    state.editVehicleState?.data == driver &&
                    state.profileState?.data == driver,
              ),
            ]),
          );

          viewModel.doIntent(
            EditVehicleEvent(
              vehicleType: 'Bike',
              vehicleNumber: '54321',
              vehicleLicense: null,
            ),
          );
          await expectation;

          verify(mockSessionController.saveUser(driver)).called(1);
        },
      );

      test(
        'should emit loading then error when EditVehicleUseCase fails',
        () async {
          const errorMessage = 'Error updating vehicle';
          when(
            mockEditVehicleUseCase.call(
              vehicleType: anyNamed('vehicleType'),
              vehicleNumber: anyNamed('vehicleNumber'),
              vehicleLicense: anyNamed('vehicleLicense'),
            ),
          ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                (state) => state.editVehicleState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                (state) =>
                    state.editVehicleState?.isLoading == false &&
                    state.editVehicleState?.errorMessage == errorMessage,
              ),
            ]),
          );

          viewModel.doIntent(
            EditVehicleEvent(
              vehicleType: 'Bike',
              vehicleNumber: '54321',
              vehicleLicense: null,
            ),
          );
          await expectation;
        },
      );
    });

    group('Logout Tests', () {
      test(
        'should emit loading then success and notify logout when LogoutUseCase succeeds',
        () async {
          when(
            mockLogoutUseCase.call(),
          ).thenAnswer((_) async => SuccessResponse(data: 'Logout successful'));

          final expectation = expectLater(
            viewModel.stream,
            emitsInOrder([
              predicate<ProfileStates>(
                (state) => state.logoutState?.isLoading == true,
              ),
              predicate<ProfileStates>(
                (state) => state.logoutState?.isLoading == false,
              ),
            ]),
          );

          viewModel.doIntent(LogoutEvent());
          await expectation;

          verify(
            mockSessionController.notifyLogout(SessionEndReason.logout),
          ).called(1);
        },
      );

      test('should emit loading then error when LogoutUseCase fails', () async {
        const errorMessage = 'Logout failed';
        when(
          mockLogoutUseCase.call(),
        ).thenAnswer((_) async => ErrorResponse(errorMessage: errorMessage));

        final expectation = expectLater(
          viewModel.stream,
          emitsInOrder([
            predicate<ProfileStates>(
              (state) => state.logoutState?.isLoading == true,
            ),
            predicate<ProfileStates>(
              (state) =>
                  state.logoutState?.isLoading == false &&
                  state.logoutState?.errorMessage == errorMessage,
            ),
          ]),
        );

        viewModel.doIntent(LogoutEvent());
        await expectation;
      });
    });
  });
}
