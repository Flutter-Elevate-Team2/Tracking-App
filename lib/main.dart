import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracking_app/core/app_router/app_router.dart';
import 'package:tracking_app/core/controller/session_controller.dart';
import 'package:tracking_app/core/helpers/session_expired_handler.dart';
import 'package:tracking_app/core/l10n/app_localizations.dart';
import 'package:tracking_app/core/l10n/view_model/language_cubit.dart';
import 'package:tracking_app/core/theming/app_theming.dart';

import 'core/di/di.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await configureDependencies();

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
      // Fix: Check mounted and pass correct context
      final context = AppRouter.rootNavigatorKey.currentContext;
      if (context != null && mounted) {
        SessionExpiredHandler.handle(context);
      }
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
      providers: [BlocProvider(create: (_) => LanguageCubit())],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            locale: locale,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: AppTheme.lightTheme,
          );
        },
      ),
    );
  }
}
