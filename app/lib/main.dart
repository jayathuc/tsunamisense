import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'l10n/app_localizations.dart';
import 'data/services/getra_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/warning_service.dart';
import 'providers/app_settings_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/earthquake_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/checklist_provider.dart';
import 'providers/safe_zone_provider.dart';
import 'providers/getra_provider.dart';
import 'providers/emergency_provider.dart';
import 'providers/theme_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/learn/learn_screen.dart';
import 'presentation/screens/map/map_screen.dart';
import 'presentation/screens/prepare/prepare_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await GetraService.initCache();
  await NotificationService.init();
  runApp(const TsunamiSenseApp());
}

class TsunamiSenseApp extends StatelessWidget {
  const TsunamiSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EarthquakeProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => ChecklistProvider()),
        ChangeNotifierProvider(create: (_) => SafeZoneProvider()),
        ChangeNotifierProvider(create: (_) => GetraProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MainNavigationScreen(),
        ),
      ),
    );
  }
}

/// Main navigation shell with bottom navigation bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  Timer? _monitorTimer;
  String? _lang; // last language the lessons/checklist were loaded for
  final WarningService _warningService = WarningService();

  final List<Widget> _screens = [
    const HomeScreen(),
    const LearnScreen(),
    const MapScreen(),
    const PrepareScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    _warningService.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final earthquakeProvider = context.read<EarthquakeProvider>();
    final getraProvider = context.read<GetraProvider>();
    final appSettings = context.read<AppSettingsProvider>();

    // Lessons and the checklist are (re)loaded from build() whenever the active
    // language changes, so they are not loaded here.
    await Future.wait([
      earthquakeProvider.fetchEarthquakes(),
      getraProvider.init(),
      appSettings.load(),
    ]);
    _startMonitoring();
  }

  /// Periodically refresh earthquakes and check for an official tsunami warning.
  void _startMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(const Duration(minutes: 3), (_) => _poll());
  }

  Future<void> _poll() async {
    if (!mounted) return;
    await context.read<EarthquakeProvider>().fetchEarthquakes();
    if (!mounted) return;
    final warning = await _warningService.fetchTsunamiWarning();
    if (warning != null && mounted) {
      final emergency = context.read<EmergencyProvider>();
      if (!emergency.active) {
        emergency.declareEmergency(source: LatLng(warning.lat, warning.lon));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nav = context.watch<NavigationProvider>();

    // Reload language-dependent content (lessons, checklist) when the locale
    // changes, preserving completion/check state by stable IDs inside each
    // provider. Also fires the first load once the saved locale is applied.
    final localeCode = context.watch<LocaleProvider>().languageCode;
    if (_lang != localeCode) {
      _lang = localeCode;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<LessonProvider>().loadLessons(lang: localeCode);
        context.read<ChecklistProvider>().loadChecklist(lang: localeCode);
      });
    }

    // Auto-switch to the Map tab the moment an emergency is declared.
    final emergency = context.watch<EmergencyProvider>();
    if (emergency.active && nav.index != 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.read<EmergencyProvider>().active) {
          context.read<NavigationProvider>().goToTab(2);
        }
      });
    }
    return Scaffold(
      body: IndexedStack(
        index: nav.index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: nav.index,
        onDestinationSelected: (index) =>
            context.read<NavigationProvider>().goToTab(index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l.navLearn,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l.navMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.checklist_outlined),
            selectedIcon: const Icon(Icons.checklist),
            label: l.navPrepare,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l.navSettings,
          ),
        ],
      ),
    );
  }
}
