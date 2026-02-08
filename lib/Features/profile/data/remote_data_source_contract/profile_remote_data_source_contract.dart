import 'package:tracking_app/Features/profile/data/models/change_password_request/change_password_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_request.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/edit_profile_response.dart';

abstract class ProfileRemoteDataSourceContract {
  Future<EditProfileResponse> editProfile(EditProfileRequest request);
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
}
