import 'package:flutter_dotenv/flutter_dotenv.dart';

// coverage:ignore-file

class ApiConstants {
  static String apiBaseUrl = dotenv.env['BASE_URL'] ?? "";

  // ================= Auth Endpoints =================
  static const String signIn = "/auth/login";
  static const String signUp = "/auth/signup";
  static const String forgetPassword = "/auth/forgotPassword";
  static const String resetPassword = "/auth/resetPassword";
  static const String verifyResetCode = "/auth/verifyResetCode";
  static const String home = "/home";
  static const String getProfile = "/auth/profile-data";
  static const String editProfile = "/auth/editProfile";
  static const String uploadPhoto = "auth/upload-photo";
  static const String changePassword = "/auth/change-password";
  static const String logout = "/auth/logout";
  //=========================EditDriverInfo======================================//
  static const String editDriverProfile = "drivers/editProfile";
  static const String changeDriverPassword = "drivers/change-password";
  static const String uploadDriverPhoto = "/drivers/upload-photo";

  // ================= Token  =================

  static const String tokenKey = "user_token";

  // ================= Notifications Endpoints =================
  static const String notifications = "notifications/user";
}
