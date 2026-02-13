import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/mockito.dart' as mockito;

import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/domain/use_cases/get_all_vehicles_use_case.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_view_model.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_events.dart';
import 'package:tracking_app/Features/vehicle/presentation/view_model/vehicle_states.dart';

import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/base_states/base_states.dart';

import 'vehicle_view_model_test.mocks.dart';

@GenerateMocks([GetAllVehiclesUseCase])
void main() {
  late VehicleViewModel viewModel;
  late MockGetAllVehiclesUseCase mockUseCase;

  VehicleStates initialState() => VehicleStates();

  setUpAll(() {
    mockito.provideDummy<BaseResponse<List<VehicleEntity>>>(
      SuccessResponse<List<VehicleEntity>>(data: []),
    );
  });

  setUp(() {
    mockUseCase = MockGetAllVehiclesUseCase();
    viewModel = VehicleViewModel(mockUseCase);
  });

  tearDown(() {
    viewModel.close();
  });

  /// ---------- Fake Data ----------
  final fakeVehicles = [
    VehicleEntity(id: "1", type: "Car", image: "car.png"),
    VehicleEntity(id: "2", type: "Bike", image: "bike.png"),
  ];

  /// ---------- Tests ----------
  group('VehicleViewModel Tests', () {

    blocTest<VehicleViewModel, VehicleStates>(
      'GetAllVehiclesEvent emits loading then vehicles list on success',
      build: () {
        when(mockUseCase.call()).thenAnswer(
              (_) async => SuccessResponse(data: fakeVehicles),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetAllVehiclesEvent()),
      expect: () => [
        isA<VehicleStates>().having(
              (s) => s.vehiclesState!.isLoading,
          'loading',
          true,
        ),
        isA<VehicleStates>().having(
              (s) => s.vehiclesState!.data,
          'data',
          fakeVehicles,
        ),
      ],
    );

    blocTest<VehicleViewModel, VehicleStates>(
      'GetAllVehiclesEvent emits error on failure',
      build: () {
        when(mockUseCase.call()).thenAnswer(
              (_) async => ErrorResponse(errorMessage: "Failed"),
        );
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetAllVehiclesEvent()),
      expect: () => [
        isA<VehicleStates>().having(
              (s) => s.vehiclesState!.isLoading,
          'loading',
          true,
        ),
        isA<VehicleStates>().having(
              (s) => s.vehiclesState!.errorMessage,
          'error',
          "Failed",
        ),
      ],
    );

    blocTest<VehicleViewModel, VehicleStates>(
      'SelectVehicleEvent updates selectedVehicle',
      build: () => viewModel,
      seed: () => initialState().copyWith(
        vehiclesState: BaseState(data: fakeVehicles),
      ),
      act: (bloc) =>
          bloc.doIntent(SelectVehicleEvent(vehicleId: "2")),
      expect: () => [
        isA<VehicleStates>().having(
              (s) => s.selectedVehicle?.id,
          'selected id',
          "2",
        ),
      ],
    );
  });
}
