import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class StartOrderUseCase {
  final HomeRepoContract _repo;

  StartOrderUseCase(this._repo);

  Future<BaseResponse<OrderEntity>> call(String id) async {
    return await _repo.startOrder(id);
  }
}
