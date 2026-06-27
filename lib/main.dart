import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/services/getra_service.dart';
import 'providers/earthquake_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/checklist_provider.dart';
import 'providers/safe_zone_provider.dart';
import 'providers/getra_provider.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
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
  int _currentIndex = 0;

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
    // Initialize data on app start
    _initializeData();
  }

  Future<void> _initializeData() async {
    final earthquakeProvider = context.read<EarthquakeProvider>();
    final lessonProvider = context.read<LessonProvider>();
    final checklistProvider = context.read<ChecklistProvider>();
    final getraProvider = context.read<GetraProvider>();

    // Load data in parallel
    await Future.wait([
      earthquakeProvider.fetchEarthquakes(),
      lessonProvider.loadLessons(),
      checklistProvider.loadChecklist(),
      getraProvider.init(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Prepare',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
