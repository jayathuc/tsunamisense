import 'package:flutter/foundation.dart';

/// Single source of truth for the bottom-navigation tab index, so any screen
/// (or the emergency flow) can switch tabs.
/// Tabs: 0 Home, 1 Learn, 2 Map, 3 Prepare, 4 Settings.
class NavigationProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void goToTab(int i) {
    if (i == _index) return;
    _index = i;
    notifyListeners();
  }
}
