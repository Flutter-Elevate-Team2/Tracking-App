import 'package:tracking_app/Features/order/data/models/user_dto.dart';
import 'package:tracking_app/Features/order/domain/entities/user_entity.dart';

extension UserMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
      passwordChangedAt: passwordChangedAt,
      passwordResetCode: passwordChangedAt,
      passwordResetExpires: passwordResetExpires,
      resetCodeVerified: resetCodeVerified,
      phone: phone,
      photo: photo,
    );
  }
}
