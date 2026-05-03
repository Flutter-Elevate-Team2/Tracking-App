import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? passwordChangedAt;
  final String? passwordResetCode;
  final String? passwordResetExpires;
  final bool? resetCodeVerified;

  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.passwordChangedAt,
    this.passwordResetCode,
    this.passwordResetExpires,
    this.resetCodeVerified,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    gender,
    phone,
    photo,
    passwordChangedAt,
    passwordResetCode,
    passwordResetExpires,
    resetCodeVerified,
  ];
}
