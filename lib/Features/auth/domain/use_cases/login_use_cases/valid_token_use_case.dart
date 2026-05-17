import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/data/auth_data_source_contract/auth_local_data_source_contract.dart';

@injectable
class HasValidTokenUseCase {
  final AuthLocalDataSourceContract _local;

  HasValidTokenUseCase(this._local);

  Future<bool> call() async {
    final token = await _local.getToken();
    return token != null && token.isNotEmpty;
  }
}
