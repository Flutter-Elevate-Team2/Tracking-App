
import 'package:tracking_app/Features/profile/data/models/edit_profile_response/change_password_response/change_password_response.dart';

import '../../domain/entities/change_password_entity.dart';

extension ChangePasswordMapper on ChangePasswordResponse {
  ChangePasswordEntity toEntity() {
    return ChangePasswordEntity(
      message: message ?? '',
      token: token ?? '',
    );
  }
}