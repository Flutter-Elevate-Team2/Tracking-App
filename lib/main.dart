import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracking_app/Features/profile/domain/entities/driver_entity.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/di/di.dart'; // تأكد من المسار
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/theming/app_theming.dart';
import 'package:tracking_app/core/controller/session_controller.dart'; // import controller

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await configureDependencies();
  final mockUser = DriverEntity(
    id: "",
    firstName: "John",
    lastName: "Doe",
    email: "john.doe@example.com",
    phone:"+201234567890",
    gender:"male",
    photoUrl: '',
     role: '',
  );
  getIt<SessionController>().saveUser(mockUser);
  runApp(const MyApp());
}

// 1. حولناها لـ StatefulWidget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  // 2. بنعرف المتغير عشان نقفله في الآخر
  late final SessionController _sessionController;

  @override
  void initState() {
    super.initState();
    // بنجيب النسخة من GetIt
    _sessionController = getIt<SessionController>();

    // 🔥 3. هنا اللوجيك الحقيقي!
    // اسمع لانتهاء السيشن
    _sessionController.onSessionExpired.listen((_) {
      print("🚨 Session Expired! Redirecting to Login...");
      
      AppRouter.router.goNamed(Routes.editProfileName); 
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router, 
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.lightTheme,
    );
  }
}