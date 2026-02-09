import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class LoginUseCase {
  final AuthRepoContract _authRepo;

  LoginUseCase(this._authRepo);

  Future<BaseResponse<LoginEntity>> call(
    LoginRequest request, {
    required bool isRememberMe,
  }) {
    return _authRepo.login(request, isRememberMe);
  }
}
