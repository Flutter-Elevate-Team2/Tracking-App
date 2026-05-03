import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/Features/home/domain/repo/home_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class GetPendingOrdersUseCase {
  final HomeRepoContract _repo;

  GetPendingOrdersUseCase(this._repo);

  Future<BaseResponse<HomeOrdersEntity>> call(int page) async {
    return await _repo.getPendingOrders(page);
  }
}
