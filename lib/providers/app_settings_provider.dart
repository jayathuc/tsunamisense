import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-level settings. Currently holds the developer-mode flag that reveals
/// the simulate/test controls; off by default so the app looks like a citizen
/// would use it.
class AppSettingsProvider extends ChangeNotifier {
  bool _developerMode = false;
  bool get developerMode => _developerMode;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _developerMode = prefs.getBool('developer_mode') ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setDeveloperMode(bool value) async {
    _developerMode = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('developer_mode', value);
    } catch (_) {}
  }
}
