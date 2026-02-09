import 'package:tracking_app/Features/auth/data/models/apply_models/apply_request.dart';
import 'package:tracking_app/Features/auth/data/models/apply_models/apply_response.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_request.dart';
import 'package:tracking_app/Features/auth/data/models/login_models/login_response.dart';

abstract class AuthRemoteDataSourceContract {
  Future<ApplyResponse> apply(ApplyRequest request);
  Future<LoginResponse> login(LoginRequest request);
}
