import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/profile/domain/repo/profile_repo_contract.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

@injectable
class UploadPhotoUseCase {
  final ProfileRepoContract _repo;

  UploadPhotoUseCase(this._repo);

  Future<BaseResponse<String>> call(File file) async {
    return await _repo.uploadPhoto(file);
  }
}