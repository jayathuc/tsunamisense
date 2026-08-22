import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/district_name.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/checklist_provider.dart';
import '../../../providers/getra_provider.dart';
import '../../../providers/app_settings_provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/tile_prefetch_service.dart';

/// Settings screen - App settings and preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _showAllEarthquakes = false;
  double _alertRadius = 500; // km
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _showAllEarthquakes = prefs.getBool('show_all_earthquakes') ?? false;
      _alertRadius = prefs.getDouble('alert_radius') ?? 500;
      _darkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsTitle),
      ),
      body: ListView(
        children: [
          // Notification Settings
          _SectionHeader(title: l.sectionNotifications),
          SwitchListTile(
            title: Text(l.enableNotifications),
            subtitle: Text(l.enableNotificationsSubtitle),
            value: _notificationsEnabled,
            onChanged: (value) async {
              setState(() => _notificationsEnabled = value);
              await _saveSetting('notifications_enabled', value);
              await NotificationService.refreshPrefs();
            },
          ),
          if (_notificationsEnabled) ...[
            SwitchListTile(
              title: Text(l.soundLabel),
              subtitle: Text(l.soundSubtitle),
              value: _soundEnabled,
              onChanged: (value) async {
                setState(() => _soundEnabled = value);
                await _saveSetting('sound_enabled', value);
                await NotificationService.refreshPrefs();
              },
            ),
            SwitchListTile(
              title: Text(l.vibrationLabel),
              subtitle: Text(l.vibrationSubtitle),
              value: _vibrationEnabled,
              onChanged: (value) async {
                setState(() => _vibrationEnabled = value);
                await _saveSetting('vibration_enabled', value);
                await NotificationService.refreshPrefs();
              },
            ),
          ],

          const Divider(),

          // Alert Settings
          _SectionHeader(title: l.sectionAlertSettings),
          ListTile(
            title: Text(l.alertRadius),
            subtitle: Text(l.alertRadiusValue(_alertRadius.toInt())),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: _alertRadius,
                min: 100,
                max: 1000,
                divisions: 9,
                label: '${_alertRadius.toInt()} km',
                onChanged: (value) {
                  setState(() => _alertRadius = value);
                  _saveSetting('alert_radius', value);
                },
              ),
            ),
          ),
          SwitchListTile(
            title: Text(l.showAllEarthquakes),
            subtitle: Text(l.showAllEarthquakesSubtitle),
            value: _showAllEarthquakes,
            onChanged: (value) {
              setState(() => _showAllEarthquakes = value);
              _saveSetting('show_all_earthquakes', value);
            },
          ),
          if (context.watch<AppSettingsProvider>().developerMode)
            ListTile(
              title: Text(l.testAlert),
              subtitle: Text(l.testAlertSubtitle),
              trailing: const Icon(Icons.notifications_active),
              onTap: _sendTestAlert,
            ),

          const Divider(),

          // Display Settings
          _SectionHeader(title: l.sectionDisplay),
          ListTile(
            title: Text(l.language),
            subtitle: Text(LocaleProvider.displayName(
                context.watch<LocaleProvider>().languageCode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context),
          ),
          SwitchListTile(
            title: Text(l.darkMode),
            subtitle: Text(l.darkModeSubtitle),
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              context.read<ThemeProvider>().setDarkMode(value);
            },
          ),

          const Divider(),

          // Evacuation Map
          _SectionHeader(title: l.sectionEvacuationMap),
          SwitchListTile(
            title: Text(l.showResearchShelters),
            subtitle: Text(l.showResearchSheltersSubtitle),
            secondary: const Icon(Icons.menu_book_outlined),
            value: context.watch<GetraProvider>().showLiteratureShelters,
            onChanged: (value) =>
                context.read<GetraProvider>().setShowLiteratureShelters(value),
          ),
          SwitchListTile(
            title: Text(l.showOsmShelters),
            subtitle: Text(l.showOsmSheltersSubtitle),
            secondary: const Icon(Icons.public),
            value: context.watch<GetraProvider>().showOsmShelters,
            onChanged: (value) =>
                context.read<GetraProvider>().setShowOsmShelters(value),
          ),

          const Divider(),

          // Data & Storage
          _SectionHeader(title: l.sectionDataStorage),
          ListTile(
            title: Text(l.offlineMode),
            subtitle: Text(l.offlineModeSubtitle),
            trailing: const Icon(Icons.download_for_offline_outlined),
            onTap: _downloadOfflineData,
          ),
          ListTile(
            title: Text(l.clearCache),
            subtitle: Text(l.clearCacheSubtitle),
            trailing: const Icon(Icons.delete_outline),
            onTap: _clearCache,
          ),
          ListTile(
            title: Text(l.exportData),
            subtitle: Text(l.exportDataSubtitle),
            trailing: const Icon(Icons.download),
            onTap: _exportData,
          ),

          const Divider(),

          // Developer
          _SectionHeader(title: l.sectionDeveloper),
          SwitchListTile(
            title: Text(l.developerMode),
            subtitle: Text(l.developerModeSubtitle),
            secondary: const Icon(Icons.developer_mode),
            value: context.watch<AppSettingsProvider>().developerMode,
            onChanged: (v) =>
                context.read<AppSettingsProvider>().setDeveloperMode(v),
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: l.sectionAbout),
          ListTile(
            title: Text(l.aboutTsunamiSense),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(),
          ),
          ListTile(
            title: Text(l.termsOfService),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsOfService(),
          ),
          ListTile(
            title: Text(l.openSourceLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLicenses(context),
          ),

          const Divider(),

          // Emergency Contacts
          _SectionHeader(title: l.sectionEmergencyContacts),
          _EmergencyContactTile(
            title: l.contactNationalDisaster,
            number: '117',
            icon: Icons.local_police,
          ),
          _EmergencyContactTile(
            title: l.contactPolice,
            number: '119',
            icon: Icons.security,
          ),
          _EmergencyContactTile(
            title: l.contactAmbulance,
            number: '1990',
            icon: Icons.local_hospital,
          ),
          _EmergencyContactTile(
            title: l.contactFire,
            number: '110',
            icon: Icons.local_fire_department,
          ),

          const SizedBox(height: 32),

          // Version info
          Center(
            child: Column(
              children: [
                Text(
                  'TsunamiSense',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Version ${AppConstants.appVersion}',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                Text(
                  '© 2025 FYP Project',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _sendTestAlert() {
    final l = AppLocalizations.of(context);
    NotificationService.show('TsunamiSense', l.testAlertSubtitle);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.testNotificationSent)),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l = AppLocalizations.of(context);
    final localeProvider = context.read<LocaleProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleProvider.supported.map((loc) {
            final selected =
                localeProvider.languageCode == loc.languageCode;
            return ListTile(
              title: Text(LocaleProvider.displayName(loc.languageCode)),
              trailing: selected
                  ? const Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              onTap: () {
                localeProvider.setLocale(loc);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _downloadOfflineData() async {
    final l = AppLocalizations.of(context);
    final district = context.read<GetraProvider>().selected;
    if (district == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.offlineDownloadFailed)),
      );
      return;
    }

    final districtName = localizedDistrictName(l, district.id, district.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.offlineDownloadTitle),
        content: Text(l.offlineDownloadBody(districtName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.offlineDownloadStart),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final service = TilePrefetchService();
    final progress = ValueNotifier<int>(0);
    final total = TilePrefetchService.estimateCount(district.bbox);
    var cancelledByUser = false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l.offlineDownloading),
        content: ValueListenableBuilder<int>(
          valueListenable: progress,
          builder: (_, done, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: total == 0 ? null : done / total),
              const SizedBox(height: 12),
              Text(l.offlineDownloadProgress(done, total)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              cancelledByUser = true;
              service.cancel();
              Navigator.pop(ctx);
            },
            child: Text(l.commonCancel),
          ),
        ],
      ),
    );

    final completed = await service.prefetch(
      district.bbox,
      headers: const {
        'User-Agent': 'TsunamiSense/1.0 (tsunami evacuation app)',
      },
      onProgress: (done, _) => progress.value = done,
    );

    if (!cancelledByUser && mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // close progress dialog
    }
    progress.dispose();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(completed
            ? l.offlineDownloadDone(districtName)
            : l.offlineDownloadFailed),
      ),
    );
  }

  void _clearCache() async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.clearCacheTitle),
        content: Text(l.clearCacheBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.commonClear),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      // Preserve user settings; remove only cached app data
      final keysToKeep = {
        'notifications_enabled', 'sound_enabled', 'vibration_enabled',
        'show_all_earthquakes', 'alert_radius', 'locale_code', 'dark_mode',
        'offline_mode', 'checklist_data', 'developer_mode',
        'show_literature_shelters', 'show_osm_shelters',
      };
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (!keysToKeep.contains(key)) {
          await prefs.remove(key);
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.cacheCleared)),
        );
      }
    }
  }

  void _exportData() {
    final provider = context.read<ChecklistProvider>();
    final buffer = StringBuffer();
    buffer.writeln('TsunamiSense — Emergency Preparedness Checklist');
    buffer.writeln('Generated: ${DateTime.now().toLocal()}');
    buffer.writeln('');
    buffer.writeln(
      'Overall: ${provider.completedItemsCount}/${provider.totalItemsCount} '
      '(${(provider.completionPercentage * 100).toStringAsFixed(0)}%)',
    );
    buffer.writeln('');
    for (final category in provider.categories) {
      buffer.writeln('${category.icon} ${category.name}');
      for (final item in category.items) {
        final status = item.isCompleted ? '[x]' : '[ ]';
        buffer.writeln('  $status ${item.name}');
        if (item.note != null) buffer.writeln('      Note: ${item.note}');
      }
      buffer.writeln('');
    }
    Share.share(buffer.toString(), subject: 'TsunamiSense Emergency Checklist');
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('🌊', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 12),
            const Text('TsunamiSense'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'An education-first tsunami preparedness app for Sri Lanka.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Real-time earthquake monitoring'),
              Text('• Tsunami education modules'),
              Text('• Safe zone maps'),
              Text('• Emergency preparedness checklist'),
              Text('• Multi-language support'),
              SizedBox(height: 16),
              Text(
                'Data Sources:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• USGS Earthquake Hazards Program'),
              Text('• GDACS Global Disaster Alert System'),
              Text('• OpenStreetMap'),
              Text('• Disaster Management Centre, Sri Lanka'),
              SizedBox(height: 16),
              Text(
                'This app is developed as a Final Year Project at IIT.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).commonClose),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).settingsPrivacyPolicy)),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Text(
              '''Privacy Policy for TsunamiSense

Last updated: August 2026

TsunamiSense is academic research software produced as a final-year project. It
is not an official warning system.

1. What stays on your device
- Your position is read only while you ask for a route or view the map. It is
  not recorded, and no location history is kept.
- Your preparedness checklist, lesson progress and settings are stored locally
  and are never uploaded.
- Map data, shelters and routing tables are cached on the device so the app
  works offline. Evacuation routes are calculated on your phone.

2. What leaves your device
- If the app cannot calculate a route locally, it may send a single set of
  coordinates to the GETRA routing service to request one. Those coordinates
  are used to answer that request and are not linked to any identifier.
- Requesting map tiles and earthquake data necessarily reveals your device's IP
  address to those providers, as with any web request.

3. What we do not do
- No analytics, tracking or advertising.
- No accounts, and no personal information is collected.
- Nothing is sold or shared with third parties.

4. Third-party services
- USGS: earthquake data
- GDACS: official tsunami bulletins
- OpenStreetMap and CARTO: map tiles
- GETRA API: hazard data and optional routing

5. Permissions
- Location: to place you on the map and route you to shelter.
- Notifications: to alert you to earthquakes and tsunami warnings, including
  while the app is closed.

6. Contact
tsunamisense@fyp.edu''',
              style: TextStyle(height: 1.6),
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).settingsTermsOfService)),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Text(
              '''Terms of Service for TsunamiSense

Last updated: January 2025

1. Acceptance of Terms
By using TsunamiSense, you agree to these terms.

2. Disclaimer
This app is for educational purposes and should not be the sole source of information during an emergency. Always follow official government advisories.

3. Accuracy
While we strive for accuracy, earthquake data and tsunami warnings are provided by third-party services. We cannot guarantee the accuracy or timeliness of this information.

4. Limitation of Liability
We are not liable for any damages arising from the use of this app. In emergency situations, always follow official guidance from local authorities.

5. Changes to Terms
We may update these terms at any time. Continued use of the app constitutes acceptance of new terms.

6. Contact
For questions, contact: tsunamisense@fyp.edu''',
              style: TextStyle(height: 1.6),
            ),
          ),
        ),
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'TsunamiSense',
      applicationVersion: AppConstants.appVersion,
      applicationLegalese: '© 2025 FYP Project',
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _EmergencyContactTile extends StatelessWidget {
  final String title;
  final String number;
  final IconData icon;

  const _EmergencyContactTile({
    required this.title,
    required this.number,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.alertRed.withValues(alpha: 0.1),
        child: Icon(icon, color: AppTheme.alertRed),
      ),
      title: Text(title),
      subtitle: Text(
        number,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.phone),
        onPressed: () async {
          final uri = Uri(scheme: 'tel', path: number);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not launch dialler for $number')),
              );
            }
          }
        },
      ),
    );
  }
}
