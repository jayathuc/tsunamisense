import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/earthquake_provider.dart';
import '../../../providers/emergency_provider.dart';
import '../../../data/models/earthquake.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

/// Alerts screen - Earthquake monitoring and alert history
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  double _minMagnitudeFilter = 5.0; // default: show all M5+

  List<Earthquake> _applyFilter(List<Earthquake> earthquakes) {
    return earthquakes
        .where((eq) => eq.magnitude >= _minMagnitudeFilter)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Fetch earthquakes on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EarthquakeProvider>().fetchEarthquakes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EarthquakeProvider>().fetchEarthquakes();
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Consumer<EarthquakeProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchEarthquakes(),
            child: CustomScrollView(
              slivers: [
                // Current Status Card
                SliverToBoxAdapter(
                  child: _AlertStatusCard(
                    alertLevel: provider.currentAlertLevel,
                    isLoading: provider.isLoading,
                  ),
                ),

                // Demonstration: trigger the emergency evacuation flow
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<EmergencyProvider>().declareEmergency();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Emergency drill started — opening evacuation map'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.crisis_alert),
                      label: const Text('Simulate tsunami warning (drill)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.alertRed,
                        side: const BorderSide(color: AppTheme.alertRed),
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                  ),
                ),

                // Error message if any
                if (provider.errorMessage != null)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.alertRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.alertRed.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: AppTheme.alertRed),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: TextStyle(color: AppTheme.alertRed),
                            ),
                          ),
                          TextButton(
                            onPressed: () => provider.fetchEarthquakes(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Statistics summary
                SliverToBoxAdapter(
                  child: _EarthquakeStats(earthquakes: provider.earthquakes),
                ),

                // Section header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Earthquakes',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${_applyFilter(provider.earthquakes).length} events'
                          '${_minMagnitudeFilter > 5.0 ? ' (M${_minMagnitudeFilter.toStringAsFixed(1)}+)' : ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),

                // Loading indicator
                if (provider.isLoading && provider.earthquakes.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                // Empty state
                else if (_applyFilter(provider.earthquakes).isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: AppTheme.alertGreen,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No earthquakes match filter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No earthquakes above M${_minMagnitudeFilter.toStringAsFixed(1)} in the Indian Ocean region.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                // Earthquake list
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final earthquake = _applyFilter(provider.earthquakes)[index];
                          return _EarthquakeCard(
                            earthquake: earthquake,
                            onTap: () => _showEarthquakeDetails(context, earthquake),
                          );
                        },
                        childCount: _applyFilter(provider.earthquakes).length,
                      ),
                    ),
                  ),

                // Last updated info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        provider.lastUpdated != null
                            ? 'Last updated: ${_formatTime(provider.lastUpdated!)}'
                            : 'Pull down to refresh',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Earthquakes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.filter_1,
                color: _minMagnitudeFilter == 5.0 ? AppTheme.primaryBlue : null,
              ),
              title: const Text('All (M5.0+)'),
              subtitle: const Text('Show all significant earthquakes'),
              trailing: _minMagnitudeFilter == 5.0
                  ? Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              onTap: () {
                setState(() => _minMagnitudeFilter = 5.0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.warning_amber,
                color: _minMagnitudeFilter == 6.0 ? AppTheme.alertYellow : null,
              ),
              title: const Text('Strong (M6.0+)'),
              subtitle: const Text('Advisory level events'),
              trailing: _minMagnitudeFilter == 6.0
                  ? Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              onTap: () {
                setState(() => _minMagnitudeFilter = 6.0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.dangerous,
                color: _minMagnitudeFilter == 7.0 ? AppTheme.alertRed : null,
              ),
              title: const Text('Major (M7.0+)'),
              subtitle: const Text('Emergency level events'),
              trailing: _minMagnitudeFilter == 7.0
                  ? Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              onTap: () {
                setState(() => _minMagnitudeFilter = 7.0);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showEarthquakeDetails(BuildContext context, Earthquake earthquake) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: _EarthquakeDetailSheet(earthquake: earthquake),
        ),
      ),
    );
  }
}

class _AlertStatusCard extends StatelessWidget {
  final AlertLevel alertLevel;
  final bool isLoading;

  const _AlertStatusCard({
    required this.alertLevel,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getAlertColor(alertLevel),
            _getAlertColor(alertLevel).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getAlertColor(alertLevel).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    _getAlertIcon(alertLevel),
                    color: Colors.white,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getAlertTitle(alertLevel),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getAlertSubtitle(alertLevel),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  IconData _getAlertIcon(AlertLevel level) {
    switch (level) {
      case AlertLevel.none:
        return Icons.check_circle;
      case AlertLevel.advisory:
        return Icons.info;
      case AlertLevel.warning:
        return Icons.warning_amber;
      case AlertLevel.emergency:
        return Icons.dangerous;
    }
  }

  String _getAlertTitle(AlertLevel level) {
    switch (level) {
      case AlertLevel.none:
        return 'All Clear';
      case AlertLevel.advisory:
        return 'Advisory';
      case AlertLevel.warning:
        return 'Warning';
      case AlertLevel.emergency:
        return 'EMERGENCY';
    }
  }

  String _getAlertSubtitle(AlertLevel level) {
    switch (level) {
      case AlertLevel.none:
        return 'No tsunami threat to Sri Lanka at this time';
      case AlertLevel.advisory:
        return 'Significant earthquake detected. Stay informed.';
      case AlertLevel.warning:
        return 'Strong earthquake detected. Prepare to evacuate.';
      case AlertLevel.emergency:
        return 'Major earthquake! Evacuate to high ground immediately!';
    }
  }
}

class _EarthquakeStats extends StatelessWidget {
  final List<Earthquake> earthquakes;

  const _EarthquakeStats({required this.earthquakes});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final last24h = earthquakes.where((e) => now.difference(e.time).inHours < 24).length;
    final last7d = earthquakes.where((e) => now.difference(e.time).inDays < 7).length;
    final maxMag = earthquakes.isNotEmpty
        ? earthquakes.map((e) => e.magnitude).reduce((a, b) => a > b ? a : b)
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatCard(
            label: 'Last 24h',
            value: last24h.toString(),
            icon: Icons.access_time,
          ),
          _StatCard(
            label: 'Last 7 days',
            value: last7d.toString(),
            icon: Icons.calendar_today,
          ),
          _StatCard(
            label: 'Max Magnitude',
            value: maxMag > 0 ? 'M${maxMag.toStringAsFixed(1)}' : 'N/A',
            icon: Icons.speed,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryBlue),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarthquakeCard extends StatelessWidget {
  final Earthquake earthquake;
  final VoidCallback onTap;

  const _EarthquakeCard({
    required this.earthquake,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeDiff = DateTime.now().difference(earthquake.time);
    String timeAgo;
    if (timeDiff.inMinutes < 60) {
      timeAgo = '${timeDiff.inMinutes}m ago';
    } else if (timeDiff.inHours < 24) {
      timeAgo = '${timeDiff.inHours}h ago';
    } else {
      timeAgo = '${timeDiff.inDays}d ago';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Magnitude circle
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: earthquake.alertColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: earthquake.alertColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'M${earthquake.magnitude.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: earthquake.alertColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      earthquake.place,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${earthquake.depth.toStringAsFixed(1)} km deep',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Alert indicator
              if (earthquake.magnitude >= AppConstants.advisoryMagnitude)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: earthquake.alertColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    earthquake.magnitude >= AppConstants.emergencyMagnitude
                        ? '🚨 ALERT'
                        : '⚠️ Watch',
                    style: TextStyle(
                      color: earthquake.alertColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EarthquakeDetailSheet extends StatelessWidget {
  final Earthquake earthquake;

  const _EarthquakeDetailSheet({required this.earthquake});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Magnitude badge
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: earthquake.alertColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: earthquake.alertColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'M${earthquake.magnitude.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: earthquake.alertColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      earthquake.severityText,
                      style: TextStyle(
                        color: earthquake.alertColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Location
          Text(
            earthquake.place,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Details grid
          _DetailRow(
            icon: Icons.location_on,
            label: 'Location',
            value: '${earthquake.latitude.toStringAsFixed(4)}°, ${earthquake.longitude.toStringAsFixed(4)}°',
          ),
          _DetailRow(
            icon: Icons.arrow_downward,
            label: 'Depth',
            value: '${earthquake.depth.toStringAsFixed(1)} km',
          ),
          _DetailRow(
            icon: Icons.access_time,
            label: 'Time',
            value: _formatDateTime(earthquake.time),
          ),
          _DetailRow(
            icon: Icons.straighten,
            label: 'Distance from Galle',
            value: '${earthquake.distanceFromSriLanka.toStringAsFixed(0)} km',
          ),
          if (earthquake.tsunamiRisk > 0)
            _DetailRow(
              icon: Icons.waves,
              label: 'Tsunami Risk',
              value: earthquake.tsunamiRisk == 1 ? 'Possible' : 'No',
              valueColor: earthquake.tsunamiRisk == 1 ? AppTheme.alertRed : null,
            ),

          const SizedBox(height: 24),

          // Safety advice
          if (earthquake.magnitude >= AppConstants.advisoryMagnitude)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: earthquake.alertColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: earthquake.alertColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: earthquake.alertColor),
                      const SizedBox(width: 8),
                      Text(
                        'Safety Advice',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: earthquake.alertColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    earthquake.magnitude >= AppConstants.emergencyMagnitude
                        ? '🚨 This is a major earthquake that could generate a tsunami. '
                            'If you are near the coast, move to high ground immediately. '
                            'Do not wait for official warnings.'
                        : '⚠️ Monitor official sources for updates. Prepare to evacuate '
                            'if a tsunami warning is issued. Know your nearest safe zone.',
                    style: TextStyle(color: earthquake.alertColor),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _open(
                    context,
                    'https://www.google.com/maps/search/?api=1&query='
                        '${earthquake.latitude},${earthquake.longitude}',
                    'Could not open maps',
                  ),
                  icon: const Icon(Icons.map),
                  label: const Text('View on Map'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _open(
                    context,
                    earthquake.url,
                    'No USGS page available for this event',
                  ),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('USGS Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context, String url, String errorMsg) async {
    final messenger = ScaffoldMessenger.of(context);
    if (url.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(errorMsg)));
      return;
    }
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok) messenger.showSnackBar(SnackBar(content: Text(errorMsg)));
  }

  String _formatDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} UTC';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
