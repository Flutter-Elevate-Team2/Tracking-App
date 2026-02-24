import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class VerifyResetPasswordUseCase {
  final AuthRepoContract _authRepoContract;

  VerifyResetPasswordUseCase(this._authRepoContract);
  Future<BaseResponse<VerifyResetPasswordEntity>> verifyPassword(
    VerifyResetPasswordRequest request,
  ) async {
    return await _authRepoContract.verifyPassword(request);
  }
}
