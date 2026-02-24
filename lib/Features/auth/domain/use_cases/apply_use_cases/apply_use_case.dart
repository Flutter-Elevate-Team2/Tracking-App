import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApplyUseCase {
  final AuthRepoContract _authRepo;

  ApplyUseCase(this._authRepo);

  Future<BaseResponse<ApplyEntity>> call(ApplyRequest request) async {
    return await _authRepo.apply(request);
  }
}