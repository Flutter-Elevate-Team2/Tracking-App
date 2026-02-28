import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/vehicle/data/mappers/all_vehicles_mapper.dart';
import 'package:tracking_app/Features/vehicle/data/mappers/vehicle_response_mapper.dart';
import 'package:tracking_app/Features/vehicle/data/models/all_vehicles_response.dart';
import 'package:tracking_app/Features/vehicle/data/models/vehicle_response.dart';
import 'package:tracking_app/Features/vehicle/data/vehicle_data_source_contract/vehicle_remote_data_source_contract.dart';
import 'package:tracking_app/Features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:tracking_app/Features/vehicle/domain/vehicle_repo_contract/vehicle_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

@Injectable(as: VehicleRepoContract)
class VehicleRepoImpl with ApiExecutionMixin implements VehicleRepoContract {
  final VehicleRemoteDataSourceContract _remoteDataSource;

  VehicleRepoImpl(this._remoteDataSource);

  /// --- Get Vehicle ---
  @override
  Future<BaseResponse<VehicleEntity>> getVehicle(String vehicleId) async {
    return execute<VehicleResponse, VehicleEntity>(
      action: () async => await _remoteDataSource.getVehicle(vehicleId),
      mapper: (response) => response.toEntity(),
    );
  }

  /// --- Get All Vehicle ---
  @override
  Future<BaseResponse<List<VehicleEntity>>> getAllVehicles() async {
    return execute<AllVehiclesResponse, List<VehicleEntity>>(
      action: () async => await _remoteDataSource.getAllVehicles(),
      mapper: (response) => response.toEntity(),
    );
  }
}
