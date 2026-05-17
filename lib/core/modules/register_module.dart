import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// coverage:ignore-file


@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
