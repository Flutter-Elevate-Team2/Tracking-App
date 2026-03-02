import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepoContract _authRepoContract;
  ResetPasswordUseCase(this._authRepoContract);

  Future<BaseResponse<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    return await _authRepoContract.resetPassword(request);
  }
}
