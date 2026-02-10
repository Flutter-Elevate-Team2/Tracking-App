import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/data/mapper/driver_profile_mapper.dart';
import 'package:tracking_app/Features/profile/data/models/driver_profile_response.dart';
import 'package:tracking_app/Features/profile/data/remote_data_source_contract/profile_remote_data_source_contract.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepoImple with ApiExecutionMixin implements ProfileRepoContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  ProfileRepoImple(this._remoteDataSource);

  @override
  Future<BaseResponse<DriverEntity>> getDriverProfile() async {
    return execute<DriverProfileResponse, DriverEntity>(
      action: () async => await _remoteDataSource.getDriverProfile(),
      mapper: (response) => response.toEntity(),
    );
  }
}
