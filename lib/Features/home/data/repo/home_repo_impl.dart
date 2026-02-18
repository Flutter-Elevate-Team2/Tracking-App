import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/home/data/data_sources/home_data_source_contract.dart';
import 'package:tracking_app/Features/home/data/mappers/order_mapper.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

@Injectable(as: HomeRepoContract)
class HomeRepoImpl with ApiExecutionMixin implements HomeRepoContract {
  final HomeDataSourceContract _dataSource;

  HomeRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<List<OrderEntity>>> getPendingOrders() async {
    return await execute(
      action: () => _dataSource.getPendingOrders(),
      mapper: (response) => response.toEntity(),
    );
  }

  @override
  Future<BaseResponse<OrderEntity>> startOrder(String id) async {
    return await execute(
      action: () => _dataSource.startOrder(id),
      mapper: (response) => response.orders!.toEntity(),
    );
  }
}
