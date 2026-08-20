import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around flutter_local_notifications for alert notifications.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  // User preferences, mirrored from Settings.
  static bool _enabled = true;
  static bool _sound = true;
  static bool _vibration = true;

  static Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await refreshPrefs();
    _ready = true;
  }

  /// Re-read the user's notification preferences (call after Settings changes).
  static Future<void> refreshPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool('notifications_enabled') ?? true;
      _sound = prefs.getBool('sound_enabled') ?? true;
      _vibration = prefs.getBool('vibration_enabled') ?? true;
    } catch (_) {}
  }

  static Future<void> show(String title, String body,
      {bool urgent = false}) async {
    if (!_ready) return;
    // Respect the user's master toggle for non-urgent notices, but never
    // suppress a life-safety tsunami warning.
    if (!_enabled && !urgent) return;
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'tsunami_alerts',
        'Tsunami Alerts',
        channelDescription: 'Earthquake advisories and tsunami warnings',
        importance: urgent ? Importance.max : Importance.high,
        priority: urgent ? Priority.max : Priority.high,
        color: const Color(0xFFF44336),
        playSound: _sound,
        enableVibration: _vibration,
      ),
      iOS: DarwinNotificationDetails(presentSound: _sound),
    );
    await _plugin.show(urgent ? 1 : 0, title, body, details);
  }
}
