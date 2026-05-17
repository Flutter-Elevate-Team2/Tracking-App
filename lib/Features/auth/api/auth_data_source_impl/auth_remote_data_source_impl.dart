import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/api/api_client/auth_api.dart';
import 'package:tracking_app/Features/auth/data/auth_data_source_contract/auth_remote_data_source_contract.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_response.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/forget_password_request/forget_password_request.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/reset_password_request/reset_password_request.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/request/verify_reset_password_request/verify_reset_password_request.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/response/forget_password_response/forget_password_response.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/response/reset_password_response/reset_password_response.dart';
import 'package:tracking_app/Features/auth/data/models/forget_password_models/response/verify_reset_password_response/verify_reset_password_response.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_response.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApi _authApi;

  AuthRemoteDataSourceImpl(this._authApi);

  @override
  Future<ApplyResponse> apply(ApplyRequest request) async {
    return await _authApi.apply(
      request.country,
      request.firstName,
      request.lastName,
      request.vehicleType,
      request.vehicleNumber,
      request.nid,
      request.email,
      request.password,
      request.rePassword,
      request.gender,
      request.phone,
      request.vehicleLicense,
      request.nidImg,
    );
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return await _authApi.login(request);
  }

  @override
  Future<ForgetPasswordResponse> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    return await _authApi.forgetPassword(request);
  }

  @override
  Future<VerifyResetPasswordResponse> verifyPassword(
    VerifyResetPasswordRequest request,
  ) async {
    return await _authApi.verifyPassword(request);
  }

  @override
  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequest request,
  ) async {
    return await _authApi.resetPassword(request);
  }
}
