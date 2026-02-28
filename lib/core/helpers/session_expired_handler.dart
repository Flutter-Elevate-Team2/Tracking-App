import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/theming/app_theming.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionExpiredHandler {
  static bool _isShowing = false;

  static void handle() {
    if (_isShowing) return;

    final navigatorState = AppRouter.rootNavigatorKey.currentState;
    final context = navigatorState?.context;

    if (context == null || !context.mounted) {
      debugPrint("⚠️ No valid context to show session expired dialog");
      return;
    }

    _isShowing = true;

    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          localizations?.sessionExpiredTitle ?? "Session Expired",
        ),
        content: Text(
          localizations?.sessionExpiredMessage ??
              "Your session has expired. Please login again.",
        ),
        actions: [
          TextButton(
            onPressed: _onLoginPressed,
            child: Text(
              localizations?.loginTitle ?? "Login",
              style: TextStyle(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    ).then((_) => _isShowing = false);
  }

  static Future<void> _onLoginPressed() async {
    final prefs = getIt<SharedPreferences>();
    await prefs.remove(ApiConstants.tokenKey);

    final router = AppRouter.router;

    router.go(Routes.loginPath);
  }
}
