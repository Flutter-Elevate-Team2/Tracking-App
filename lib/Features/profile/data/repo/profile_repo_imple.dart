import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_imple.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';
@Injectable(as: ProfileRepoContract)
class ProfileRepoImple with ApiExecutionMixin implements ProfileRepoContract {
  
}