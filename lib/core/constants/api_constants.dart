import 'package:flutter_dotenv/flutter_dotenv.dart';

// coverage:ignore-file

class ApiConstants {
  static String apiBaseUrl = dotenv.env['BASE_URL'] ?? "";

  // ================= Auth Endpoints =================
  static const String login = "/drivers/signin";
  static const String apply = "/drivers/apply";
  static const String forgetPassword = "/drivers/forgotPassword";
  static const String resetPassword = "/drivers/resetPassword";
  static const String verifyResetCode = "/drivers/verifyResetCode";
  static const String vehicle = "/vehicles";
  static const String home = "/home";
  static const String getProfile = "/auth/profile-data";
  static const String editProfile = "/auth/editProfile";
  static const String uploadPhoto = "auth/upload-photo";
  static const String changePassword = "/auth/change-password";

  //=========================EditDriverInfo======================================//
  static const String editDriverProfile = "drivers/editProfile";
  static const String changeDriverPassword = "drivers/change-password";
  static const String uploadDriverPhoto = "/drivers/upload-photo";
  static const String logout = "/drivers/logout";
  static const String getDriverProfile = "/drivers/profile-data";
  static const String vehicles = "/vehicles";

  // ================= Order  =================
  static const String pendingOrders = "orders/pending-orders";
  static const String driverOrders = "orders/driver-orders";
  static const String updateOrderState = "orders/state/";
  static const String startOrder = "orders/start/";

  // ================= Token  =================

  static const String tokenKey = "user_token";
  static const String rememberMeKey = "is_remember_me";

  // ================= Notifications Endpoints =================
  static const String notifications = "notifications/user";

  // ================= Apply Fields =================
  static const country = 'country';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const vehicleType = 'vehicleType';
  static const vehicleNumber = 'vehicleNumber';
  static const nid = 'NID';
  static const email = 'email';
  static const password = 'password';
  static const rePassword = 'rePassword';
  static const gender = 'gender';
  static const phone = 'phone';
  static const vehicleLicense = 'vehicleLicense';
  static const nidImg = 'NIDImg';

  // ================= Orders Type  =================
  static const String pending = "pending";
  static const String completed = "completed";
  static const String cancelled = "cancelled";

// ================= Apply Fields =================
  static const country = 'country';
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const vehicleType = 'vehicleType';
  static const vehicleNumber = 'vehicleNumber';
  static const nid = 'NID';
  static const email = 'email';
  static const password = 'password';
  static const rePassword = 'rePassword';
  static const gender = 'gender';
  static const phone = 'phone';
  static const vehicleLicense = 'vehicleLicense';
  static const nidImg = 'NIDImg';
}