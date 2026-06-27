import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/checklist_provider.dart';
import '../../../providers/getra_provider.dart';

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
  String _language = 'English';
  bool _darkMode = false;
  bool _offlineMode = false;

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
      _language = prefs.getString('language') ?? 'English';
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _offlineMode = prefs.getBool('offline_mode') ?? false;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Notification Settings
          _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive earthquake and tsunami alerts'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _saveSetting('notifications_enabled', value);
            },
          ),
          if (_notificationsEnabled) ...[
            SwitchListTile(
              title: const Text('Sound'),
              subtitle: const Text('Play alert sound for notifications'),
              value: _soundEnabled,
              onChanged: (value) {
                setState(() => _soundEnabled = value);
                _saveSetting('sound_enabled', value);
              },
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              subtitle: const Text('Vibrate for notifications'),
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() => _vibrationEnabled = value);
                _saveSetting('vibration_enabled', value);
              },
            ),
          ],

          const Divider(),

          // Alert Settings
          _SectionHeader(title: 'Alert Settings'),
          ListTile(
            title: const Text('Alert Radius'),
            subtitle: Text('${_alertRadius.toInt()} km from Sri Lanka coast'),
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
            title: const Text('Show All Earthquakes'),
            subtitle: const Text('Include earthquakes below M5.0'),
            value: _showAllEarthquakes,
            onChanged: (value) {
              setState(() => _showAllEarthquakes = value);
              _saveSetting('show_all_earthquakes', value);
            },
          ),
          ListTile(
            title: const Text('Test Alert'),
            subtitle: const Text('Send a test notification'),
            trailing: const Icon(Icons.notifications_active),
            onTap: _sendTestAlert,
          ),

          const Divider(),

          // Display Settings
          _SectionHeader(title: 'Display'),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              context.read<ThemeProvider>().setDarkMode(value);
            },
          ),

          const Divider(),

          // Evacuation Map
          _SectionHeader(title: 'Evacuation Map'),
          SwitchListTile(
            title: const Text('Show research-supported shelters'),
            subtitle: const Text(
              'Also show last-resort shelters identified in published '
              'research. DMC-verified shelters are always shown.',
            ),
            secondary: const Icon(Icons.menu_book_outlined),
            value: context.watch<GetraProvider>().showLiteratureShelters,
            onChanged: (value) =>
                context.read<GetraProvider>().setShowLiteratureShelters(value),
          ),
          SwitchListTile(
            title: const Text('Show OpenStreetMap shelters'),
            subtitle: const Text(
              'Auto-identified public buildings (schools, temples, hospitals) '
              'on high ground. Unverified — enables routing for Matara and '
              'Tangalle.',
            ),
            secondary: const Icon(Icons.public),
            value: context.watch<GetraProvider>().showOsmShelters,
            onChanged: (value) =>
                context.read<GetraProvider>().setShowOsmShelters(value),
          ),

          const Divider(),

          // Data & Storage
          _SectionHeader(title: 'Data & Storage'),
          SwitchListTile(
            title: const Text('Offline Mode'),
            subtitle: const Text('Download maps for offline use'),
            value: _offlineMode,
            onChanged: (value) {
              setState(() => _offlineMode = value);
              _saveSetting('offline_mode', value);
              if (value) {
                _downloadOfflineData();
              }
            },
          ),
          ListTile(
            title: const Text('Clear Cache'),
            subtitle: const Text('Free up storage space'),
            trailing: const Icon(Icons.delete_outline),
            onTap: _clearCache,
          ),
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Export checklist and progress'),
            trailing: const Icon(Icons.download),
            onTap: _exportData,
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: 'About'),
          ListTile(
            title: const Text('About TsunamiSense'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(),
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsOfService(),
          ),
          ListTile(
            title: const Text('Open Source Licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLicenses(context),
          ),

          const Divider(),

          // Emergency Contacts
          _SectionHeader(title: 'Emergency Contacts'),
          _EmergencyContactTile(
            title: 'National Disaster Management',
            number: '117',
            icon: Icons.local_police,
          ),
          _EmergencyContactTile(
            title: 'Police Emergency',
            number: '119',
            icon: Icons.security,
          ),
          _EmergencyContactTile(
            title: 'Ambulance Service',
            number: '1990',
            icon: Icons.local_hospital,
          ),
          _EmergencyContactTile(
            title: 'Fire & Rescue',
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.notifications, color: Colors.white),
            SizedBox(width: 12),
            Text('Test alert sent!'),
          ],
        ),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Implement actual test notification using local_notifications
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              language: 'English',
              isSelected: _language == 'English',
              onSelect: () {
                setState(() => _language = 'English');
                _saveSetting('language', 'English');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              language: 'Sinhala (සිංහල)',
              isSelected: _language == 'Sinhala',
              onSelect: () {
                setState(() => _language = 'Sinhala');
                _saveSetting('language', 'Sinhala');
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              language: 'Tamil (தமிழ்)',
              isSelected: _language == 'Tamil',
              onSelect: () {
                setState(() => _language = 'Tamil');
                _saveSetting('language', 'Tamil');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _downloadOfflineData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Offline Map Tiles'),
        content: const Text(
          'Automatic tile caching is not yet implemented.\n\n'
          'Map tiles are cached automatically as you browse the map. '
          'Zoom into areas you want available offline, and the tiles '
          'will be stored by the OS network cache.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _offlineMode = false);
              _saveSetting('offline_mode', false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text(
          'This will remove cached map tiles and data. '
          'You may need to re-download them for offline use.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      // Preserve user settings; remove only cached app data
      final keysToKeep = {
        'notifications_enabled', 'sound_enabled', 'vibration_enabled',
        'show_all_earthquakes', 'alert_radius', 'language', 'dark_mode',
        'offline_mode', 'checklist_data',
      };
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (!keysToKeep.contains(key)) {
          await prefs.remove(key);
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache cleared successfully')),
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
                color: AppTheme.primaryBlue.withOpacity(0.1),
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
            child: const Text('Close'),
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
          appBar: AppBar(title: const Text('Privacy Policy')),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Text(
              '''Privacy Policy for TsunamiSense

Last updated: January 2025

1. Information We Collect
We collect minimal information to provide the app's functionality:
- Location data (optional, for showing your position on maps)
- App usage analytics (anonymous)

2. How We Use Your Information
- To provide real-time earthquake alerts
- To show your location relative to safe zones
- To improve app functionality

3. Data Storage
- All checklist data is stored locally on your device
- We do not store personal information on our servers

4. Third-Party Services
We use the following services:
- USGS for earthquake data
- OpenStreetMap for map tiles
- Firebase for notifications (optional)

5. Contact Us
For questions about this privacy policy, please contact us at:
tsunamisense@fyp.edu

This app does not collect sensitive personal information.''',
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
          appBar: AppBar(title: const Text('Terms of Service')),
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

class _LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onSelect;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(language),
      trailing: isSelected
          ? Icon(Icons.check, color: AppTheme.primaryBlue)
          : null,
      onTap: onSelect,
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
        backgroundColor: AppTheme.alertRed.withOpacity(0.1),
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
