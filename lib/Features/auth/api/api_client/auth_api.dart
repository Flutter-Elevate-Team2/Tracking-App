import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_response.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_response.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
// coverage:ignore-file

part 'auth_api.g.dart';

@lazySingleton
@RestApi()
@injectable
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(Dio dio) = _AuthApi;

  /// === Apply Endpoint ===
  @POST(ApiConstants.apply)
  @MultiPart()
  Future<ApplyResponse> apply(
    @Part(name: ApiConstants.country) String country,
    @Part(name: ApiConstants.firstName) String firstName,
    @Part(name: ApiConstants.lastName) String lastName,
    @Part(name: ApiConstants.vehicleType) String vehicleType,
    @Part(name: ApiConstants.vehicleNumber) String vehicleNumber,
    @Part(name: ApiConstants.nid) String nid,
    @Part(name: ApiConstants.email) String email,
    @Part(name: ApiConstants.password) String password,
    @Part(name: ApiConstants.rePassword) String rePassword,
    @Part(name: ApiConstants.gender) String gender,
    @Part(name: ApiConstants.phone) String phone,

    @Part(name: ApiConstants.vehicleLicense) File vehicleLicense,
    @Part(name: ApiConstants.nidImg) File nidImg,
  );

  /// === Login Endpoint ===
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// === Forget Password Endpoints ===
  @POST(ApiConstants.forgetPassword)
  Future<ForgetPasswordResponse> forgetPassword(
    @Body() ForgetPasswordRequest forgetRequest,
  );

  @POST(ApiConstants.verifyResetCode)
  Future<VerifyResetPasswordResponse> verifyPassword(
    @Body() VerifyResetPasswordRequest verifyRequest,
  );

  @PUT(ApiConstants.resetPassword)
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest resetRequest,
  );
}
