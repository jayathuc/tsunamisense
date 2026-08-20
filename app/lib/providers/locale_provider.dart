import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App language (English, Sinhala, Tamil), persisted across launches and applied
/// to [MaterialApp.locale] so the whole UI re-renders in the chosen language.
class LocaleProvider extends ChangeNotifier {
  static const List<Locale> supported = [
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  LocaleProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString('locale_code');
      if (code != null && supported.any((l) => l.languageCode == code)) {
        _locale = Locale(code);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale.languageCode == locale.languageCode) return;
    _locale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale_code', locale.languageCode);
    } catch (_) {}
  }

  /// Native display name of a language, for the selector.
  static String displayName(String code) {
    switch (code) {
      case 'si':
        return 'සිංහල';
      case 'ta':
        return 'தமிழ்';
      default:
        return 'English';
    }
  }
}
