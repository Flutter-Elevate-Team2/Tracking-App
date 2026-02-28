import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';
import 'package:tracking_app/Features/vehicle/data/vehicle_data_source_contract/vehicle_remote_data_source_contract.dart';
import 'package:tracking_app/Features/vehicle/data/vehicle_repo_impl/vehicle_repo_impl.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

import 'vehicle_repo_impl_test.mocks.dart';

@GenerateMocks([VehicleRemoteDataSourceContract])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late VehicleRepoImpl vehicleRepo;
  late MockVehicleRemoteDataSourceContract mockRemote;

  setUp(() {
    mockRemote = MockVehicleRemoteDataSourceContract();
    vehicleRepo = VehicleRepoImpl(mockRemote);
  });

  // ================= GET VEHICLE =================
  group('Vehicle Test', () {
    final String vehicleId = " ";

    final tResponse = VehicleResponse(message: 'Success', vehicle: Vehicle());

    test(
      'returns SuccessResponse<VehicleEntity> when RemoteDataSource succeeds',
      () async {
        when(mockRemote.getVehicle(vehicleId)).thenAnswer((_) async => tResponse);

        final result = await vehicleRepo.getVehicle(vehicleId);

        expect(result, isA<SuccessResponse<VehicleEntity>>());
        verify(mockRemote.getVehicle(vehicleId)).called(1);
      },
    );

    test(
      'returns ErrorResponse when RemoteDataSource throws Exception',
      () async {
        when(mockRemote.getVehicle(vehicleId)).thenThrow(Exception('Failed'));

        final result = await vehicleRepo.getVehicle(vehicleId);

        expect(result, isA<ErrorResponse>());
        verify(mockRemote.getVehicle(vehicleId)).called(1);
      },
    );
  });


  // ================= GET ALL VEHICLES =================
  group('Get All Vehicles Test', () {

    final tResponse = AllVehiclesResponse(message: 'Success', vehicles: List<Vehicle>.empty(),);

    test(
      'returns SuccessResponse<List<VehicleEntity>> when RemoteDataSource succeeds',
          () async {
        when(mockRemote.getAllVehicles()).thenAnswer((_) async => tResponse);

        final result = await vehicleRepo.getAllVehicles();

        expect(result, isA<SuccessResponse<List<VehicleEntity>>>());
        verify(mockRemote.getAllVehicles()).called(1);
      },
    );

    test(
      'returns ErrorResponse when RemoteDataSource throws Exception',
          () async {
        when(mockRemote.getAllVehicles()).thenThrow(Exception('Failed'));

        final result = await vehicleRepo.getAllVehicles();

        expect(result, isA<ErrorResponse>());
        verify(mockRemote.getAllVehicles()).called(1);
      },
    );
  });
}
