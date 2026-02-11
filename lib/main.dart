import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/constants/api_constants.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await configureDependencies();

  final prefs = getIt<SharedPreferences>();

  const String fixedToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OTg4ZDY2N2UzNjRlZjYxNDA1MWQyYjMiLCJpYXQiOjE3NzA3MDA4Nzd9.VsQuz1UaqR_p-K0lRnPCLKCtOHev5fIdv0V3GdC83Gk";

  await prefs.setString(ApiConstants.tokenKey, fixedToken);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SessionController _sessionController;

  @override
  void initState() {
    super.initState();
    _sessionController = getIt<SessionController>();

    _sessionController.onSessionExpired.listen((_) {

      AppRouter.router.goNamed(Routes.mainProfileName);
    });
    _sessionController.onLogout.listen((_) {
    print("👋 User performed Logout");
    // وديه على صفحة تسجيل الدخول
    AppRouter.router.goNamed(Routes.mainProfileName);
  });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      routerConfig: AppRouter.router,

      theme: AppTheme.lightTheme,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}
