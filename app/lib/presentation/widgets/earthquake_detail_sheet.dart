import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/earthquake.dart';

/// Open the earthquake detail sheet as a draggable bottom sheet.
void showEarthquakeDetailSheet(BuildContext context, Earthquake earthquake) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        child: EarthquakeDetailSheet(earthquake: earthquake),
      ),
    ),
  );
}

/// Details for a single earthquake, with links to the USGS page and a map.
class EarthquakeDetailSheet extends StatelessWidget {
  final Earthquake earthquake;
  const EarthquakeDetailSheet({super.key, required this.earthquake});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: earthquake.alertColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: earthquake.alertColor, width: 3),
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
                      style: TextStyle(color: earthquake.alertColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            earthquake.place,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _DetailRow(
            icon: Icons.location_on,
            label: 'Location',
            value:
                '${earthquake.latitude.toStringAsFixed(4)}°, ${earthquake.longitude.toStringAsFixed(4)}°',
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
              valueColor:
                  earthquake.tsunamiRisk == 1 ? AppTheme.alertRed : null,
            ),
          const SizedBox(height: 24),
          if (earthquake.magnitude >= AppConstants.advisoryMagnitude)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: earthquake.alertColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: earthquake.alertColor.withValues(alpha: 0.3)),
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
                  label: Text(AppLocalizations.of(context).earthquakeViewOnMap),
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
                  label: Text(AppLocalizations.of(context).earthquakeUsgsDetails),
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
    return '${time.day}/${time.month}/${time.year} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')} UTC';
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
          Text(label, style: TextStyle(color: Colors.grey[600])),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}
