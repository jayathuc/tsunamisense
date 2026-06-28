import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/earthquake_provider.dart';
import '../../../providers/emergency_provider.dart';
import '../../../providers/lesson_provider.dart';
import '../../../providers/checklist_provider.dart';
import '../../widgets/earthquake_detail_sheet.dart';

/// Home screen - Dashboard showing current status
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<EarthquakeProvider>().fetchEarthquakes();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Header
                _buildHeader(context),
                const SizedBox(height: 24),

                // Alert Status Card
                _buildAlertStatusCard(context),
                const SizedBox(height: 12),
                _buildSimulateButton(context),
                const SizedBox(height: 20),

                // Quick Actions
                _buildQuickActions(context),
                const SizedBox(height: 24),

                // Recent Earthquakes
                _buildRecentEarthquakes(context),
                const SizedBox(height: 24),

                // Progress Overview
                _buildProgressOverview(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.waves,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppConstants.appTagline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimulateButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        context.read<EmergencyProvider>().declareEmergency();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Emergency drill started — opening evacuation map'),
          duration: Duration(seconds: 2),
        ));
      },
      icon: const Icon(Icons.crisis_alert),
      label: const Text('Simulate tsunami warning (drill)'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.alertRed,
        side: const BorderSide(color: AppTheme.alertRed),
        minimumSize: const Size.fromHeight(48),
      ),
    );
  }

  Widget _buildAlertStatusCard(BuildContext context) {
    return Consumer<EarthquakeProvider>(
      builder: (context, provider, child) {
        final alertLevel = provider.currentAlertLevel;
        final color = _getAlertColor(alertLevel);

        return Card(
          color: color.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          alertLevel.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Status',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            alertLevel.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.isLoading)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  alertLevel.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (provider.lastUpdated != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${_formatTime(provider.lastUpdated!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.location_on,
                label: 'Find Safe Zone',
                color: AppTheme.alertGreen,
                onTap: () {
                  // Navigate to map tab
                  DefaultTabController.of(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.warning_amber,
                label: 'Test Alert',
                color: AppTheme.alertOrange,
                onTap: () {
                  _showTestAlertDialog(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentEarthquakes(BuildContext context) {
    return Consumer<EarthquakeProvider>(
      builder: (context, provider, child) {
        final earthquakes = provider.recentEarthquakes.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Seismic Activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (provider.error != null)
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            if (provider.isLoading && earthquakes.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (earthquakes.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 48,
                          color: AppTheme.alertGreen,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No significant earthquakes detected',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...earthquakes.map((eq) => _EarthquakeListItem(earthquake: eq)),
          ],
        );
      },
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Consumer<LessonProvider>(
                builder: (context, provider, child) {
                  return _ProgressCard(
                    icon: Icons.school,
                    label: 'Lessons',
                    progress: provider.completionPercentage,
                    detail: '${provider.completedCount}/${provider.totalCount}',
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<ChecklistProvider>(
                builder: (context, provider, child) {
                  return _ProgressCard(
                    icon: Icons.checklist,
                    label: 'Prepared',
                    progress: provider.completionPercentage,
                    detail: '${(provider.completionPercentage * 100).toInt()}%',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getAlertColor(AlertLevel level) {
    switch (level) {
      case AlertLevel.none:
        return AppTheme.alertGreen;
      case AlertLevel.advisory:
        return AppTheme.alertYellow;
      case AlertLevel.warning:
        return AppTheme.alertOrange;
      case AlertLevel.emergency:
        return AppTheme.alertRed;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  void _showTestAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Alert'),
        content: const Text(
          'This is a TEST. Select an alert level to see how the app responds.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<EarthquakeProvider>().setAlertLevel(AlertLevel.advisory);
              Navigator.pop(context);
            },
            child: const Text('Advisory 🟡'),
          ),
          TextButton(
            onPressed: () {
              context.read<EarthquakeProvider>().setAlertLevel(AlertLevel.emergency);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Emergency 🔴'),
          ),
          TextButton(
            onPressed: () {
              context.read<EarthquakeProvider>().setAlertLevel(AlertLevel.none);
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarthquakeListItem extends StatelessWidget {
  final dynamic earthquake;

  const _EarthquakeListItem({required this.earthquake});

  @override
  Widget build(BuildContext context) {
    final mag = earthquake.magnitude;
    final color = mag >= 7.0 ? AppTheme.alertRed
        : mag >= 6.0 ? AppTheme.alertOrange
        : mag >= 5.0 ? AppTheme.alertYellow
        : AppTheme.textSecondary;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'M${mag.toStringAsFixed(1)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Text(
          earthquake.place,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${earthquake.timeAgo} • Depth: ${earthquake.depth.toStringAsFixed(0)} km',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showEarthquakeDetailSheet(context, earthquake),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double progress;
  final String detail;

  const _ProgressCard({
    required this.icon,
    required this.label,
    required this.progress,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(label, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
