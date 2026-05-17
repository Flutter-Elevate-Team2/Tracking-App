import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class LogoutUseCase {
  final ProfileRepoContract _repo;

  LogoutUseCase(this._repo);

  Future<BaseResponse<String>> call() async {
    return await _repo.logout();
  }
}
