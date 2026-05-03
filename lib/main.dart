import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_events.dart';
import 'package:tracking_app/Features/profile/presentation/view_model/profile_view_model.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/helpers/session_expired_handler.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/services/push_notification_service.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

import 'core/l10n/view_model/language_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService.init();

  await dotenv.load(fileName: ".env");
  await configureDependencies();
  // final prefs = getIt<SharedPreferences>();
  //
  // const String fixedToken =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2OThkOTFjYWUzNjRlZjYxNDA1NDNkYjUiLCJpYXQiOjE3NzA4ODU1Nzh9._KydCtmQS5aGtJR-KYk_MyLYTPcgUVO7wVOBUINYZdk";

  // await prefs.setString(ApiConstants.tokenKey, fixedToken);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _sessionController = getIt<SessionController>();
  late StreamSubscription? _subscription;
  @override
  void initState() {
    super.initState();
    _subscription = _sessionController.onSessionExpired.listen((_) {
      SessionExpiredHandler.handle();
    });

    _sessionController.onLogout.listen((_) {
      AppRouter.router.goNamed(Routes.onBoardingName);
    });
  }

  @override
  void dispose() {
    // Fix: Safe cancel
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(
          create: (_) =>
              getIt<ProfileViewModel>()..doIntent(GetDriverProfileEvent()),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            locale: locale,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppTheme.lightTheme,
          );
        },
      ),
    );
  }
}
