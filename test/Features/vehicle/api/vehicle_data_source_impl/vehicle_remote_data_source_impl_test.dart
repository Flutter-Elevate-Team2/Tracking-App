import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:tracking_app/Features/vehicle/api/api_client/vehicle_api.dart';
import 'package:tracking_app/Features/vehicle/api/vehicle_data_source_impl/vehicle_remote_data_source_impl.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_dto.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';

import 'vehicle_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([VehicleApi])
void main() {
  late VehicleRemoteDataSourceImpl dataSource;
  late MockVehicleApi mockVehicleApi;

  setUp(() {
    mockVehicleApi = MockVehicleApi();
    dataSource = VehicleRemoteDataSourceImpl(mockVehicleApi);
  });

  // ================= GET VEHICLE =================
  group('Vehicle Test', () {
    final String vehicleId = "";

    final tResponse = VehicleResponse(message: 'Success', vehicle: Vehicle());

    test(
      'should return VehicleResponse when vehicleApi.getVehicle succeeds',
      () async {
        // arrange
        when(
          mockVehicleApi.getVehicle(vehicleId),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.getVehicle(vehicleId);

        // assert
        expect(result, tResponse);
        verify(mockVehicleApi.getVehicle(vehicleId)).called(1);
      },
    );

    test('should throw Exception when vehicleApi.getVehicle fails', () async {
      // arrange
      when(
        mockVehicleApi.getVehicle(vehicleId),
      ).thenThrow(Exception('API Error'));

      // act & assert
      expect(() => dataSource.getVehicle(vehicleId), throwsException);
    });
  });

  // ================= GET ALL VEHICLES =================
  group('Get All Vehicle Test', () {
    final tResponse = AllVehiclesResponse(
      message: 'Success',
      vehicles: List<Vehicle>.empty(),
    );

    test(
      'should return AllVehicleResponse when vehicleApi.getAllVehicles succeeds',
      () async {
        // arrange
        when(
          mockVehicleApi.getAllVehicles(),
        ).thenAnswer((_) async => tResponse);

        // act
        final result = await dataSource.getAllVehicles();

        // assert
        expect(result, tResponse);
        verify(mockVehicleApi.getAllVehicles()).called(1);
      },
    );

    test(
      'should throw Exception when vehicleApi.getAllVehicles fails',
      () async {
        // arrange
        when(mockVehicleApi.getAllVehicles()).thenThrow(Exception('API Error'));

        // act & assert
        expect(() => dataSource.getAllVehicles(), throwsException);
      },
    );
  });
}
