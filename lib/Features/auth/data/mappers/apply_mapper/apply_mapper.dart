import 'package:tracking_app/Features/auth/data/models/apply_models/apply_response.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';

extension ApplyResponseMapper on ApplyResponse {
  ApplyEntity toEntity() {
    return ApplyEntity(message: message, token: token);
  }
}
