import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/constants/api_constants.dart';

enum SessionEndReason { logout, guest, passwordChanged }

@singleton
class SessionController {
  final SharedPreferences _prefs;
  
  DriverEntity? _currentUser;

  SessionController(this._prefs);

  DriverEntity? get user => _currentUser;

  // --- Streams (Event Bus) ---
  final StreamController<void> _sessionExpiredController =
      StreamController<void>.broadcast();

  final StreamController<void> _loginController =
      StreamController<void>.broadcast();

  final StreamController<SessionEndReason> _logoutController =
      StreamController<SessionEndReason>.broadcast();

  Stream<void> get onSessionExpired => _sessionExpiredController.stream;
  Stream<void> get onLogin => _loginController.stream;
  Stream<SessionEndReason> get onLogout => _logoutController.stream;



  void saveUser(DriverEntity user) {
    _currentUser = user;
  }

  Future<void> updateSessionAuth(String newToken) async {
    await _prefs.setString(ApiConstants.tokenKey, newToken);
    
   
  }

  Future<void> expireSession() async {
    await _prefs.remove(ApiConstants.tokenKey);
    _currentUser = null;
    
    if (!_sessionExpiredController.isClosed) {
      _sessionExpiredController.add(null);
    }
  }

  void notifyLogin() {
    if (!_loginController.isClosed) {
      _loginController.add(null);
    }
  }

  Future<void> notifyLogout(SessionEndReason reason) async {
    await _prefs.remove(ApiConstants.tokenKey);
    _currentUser = null; 
    
    if (!_logoutController.isClosed) {
      _logoutController.add(reason);
    }
  }

  @disposeMethod
  void dispose() {
    _sessionExpiredController.close();
    _loginController.close();
    _logoutController.close();
  }
}