import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/domain/entities/apply_entity/apply_entity.dart';
import 'package:tracking_app/Features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:tracking_app/core/base_response/base_response.dart';

abstract class AuthRepoContract {

  Future<BaseResponse<ApplyEntity>> apply(ApplyRequest request);

  Future<BaseResponse<LoginEntity>> login(
    LoginRequest request,
    bool isRememberMe,
  );

  Future<bool> isLoggedIn();

}
