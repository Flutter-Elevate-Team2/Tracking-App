import 'package:injectable/injectable.dart';
import 'package:tracking_app/Features/auth/data/auth_data_source_contract/auth_local_data_source_contract.dart';
import 'package:tracking_app/Features/auth/data/auth_data_source_contract/auth_remote_data_source_contract.dart';
import 'package:tracking_app/Features/auth/data/mappers/apply_mapper/apply_mapper.dart';
import 'package:tracking_app/Features/auth/data/mappers/forget_password_mappers/forget_password_mapper.dart';
import 'package:tracking_app/Features/auth/data/mappers/forget_password_mappers/reset_password_mapper.dart';
import 'package:tracking_app/Features/auth/data/mappers/forget_password_mappers/verify_reset_password_mapper.dart';
import 'package:tracking_app/Features/auth/data/mappers/login_mapper/login_mapper.dart';
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
import 'package:tracking_app/Features/auth/domain/auth_repo_contract/auth_repo_contract.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/Features/auth/domain/entities/forget_password_entities/forget_password_entity.dart';
import 'package:tracking_app/Features/auth/domain/entities/forget_password_entities/reset_password_entity.dart';
import 'package:tracking_app/Features/auth/domain/entities/forget_password_entities/verify_reset_password_entity.dart';
import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';
import 'package:tracking_app/core/helpers/api_execution_mixin.dart';

@Injectable(as: AuthRepoContract)
class AuthRepoImpl with ApiExecutionMixin implements AuthRepoContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthLocalDataSourceContract _localDataSource;

  AuthRepoImpl(this._remoteDataSource, this._localDataSource);

  /// --- Apply ---
  @override
  Future<BaseResponse<ApplyEntity>> apply(ApplyRequest request) async {
    return execute<ApplyResponse, ApplyEntity>(
      action: () async => await _remoteDataSource.apply(request),
      mapper: (response) => response.toEntity(),
    );
  }

  /// --- Login ---
  @override
  Future<BaseResponse<LoginEntity>> login(
    LoginRequest request,
    bool isRememberMe,
  ) async {
    final result = await execute<LoginResponse, LoginEntity>(
      action: () async => await _remoteDataSource.login(request),
      mapper: (response) => response.toEntity(),
    );

    if (result is SuccessResponse<LoginEntity>) {
      final token = result.data.token;
      if (token != null && token.isNotEmpty) {
        await _localDataSource.saveToken(token);
        await _localDataSource.saveRememberMe(isRememberMe);
      }
    }
    return result;
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localDataSource.getToken();
    final isRememberMe = await _localDataSource.getRememberMe();

    return (token != null && token.isNotEmpty) && isRememberMe;
  }

  /// --- Forget Password ---
  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    return execute<ForgetPasswordResponse, ForgetPasswordEntity>(
      action: () async => await _remoteDataSource.forgetPassword(request),
      mapper: (response) => response.toEntity(),
    );
  }

  /// --- Verify Reset Password ---
  @override
  Future<BaseResponse<VerifyResetPasswordEntity>> verifyPassword(
    VerifyResetPasswordRequest request,
  ) async {
    return execute<VerifyResetPasswordResponse, VerifyResetPasswordEntity>(
      action: () async => await _remoteDataSource.verifyPassword(request),
      mapper: (response) => response.toEntity(),
    );
  }

  /// --- Reset Password ---
  @override
  Future<BaseResponse<ResetPasswordEntity>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    return execute<ResetPasswordResponse, ResetPasswordEntity>(
      action: () async => await _remoteDataSource.resetPassword(request),
      mapper: (response) => response.toEntity(),
    );
  }
}
