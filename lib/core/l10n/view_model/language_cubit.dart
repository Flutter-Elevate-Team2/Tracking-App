import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracking_app/core/di/di.dart';

@singleton
class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = getIt<SharedPreferences>();

    await prefs.setString('locale', languageCode);

    emit(Locale(languageCode));
  }

  void _loadSavedLanguage() {
    final prefs = getIt<SharedPreferences>();

    final savedLang = prefs.getString('locale');

    if (savedLang != null) {
      emit(Locale(savedLang));
    }
  }
}
