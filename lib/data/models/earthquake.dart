import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// Earthquake data model from USGS API
class Earthquake {
  final String id;
  final double magnitude;
  final String place;
  final DateTime time;
  final double latitude;
  final double longitude;
  final double depth;
  final String? tsunamiFlag;
  final String? alert;
  final String url;

  Earthquake({
    required this.id,
    required this.magnitude,
    required this.place,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.depth,
    this.tsunamiFlag,
    this.alert,
    required this.url,
  });

  /// Create from USGS GeoJSON feature
  factory Earthquake.fromUsgsJson(Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>;
    final geometry = feature['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;

    return Earthquake(
      id: feature['id'] as String,
      magnitude: (properties['mag'] as num?)?.toDouble() ?? 0.0,
      place: properties['place'] as String? ?? 'Unknown location',
      time: DateTime.fromMillisecondsSinceEpoch(properties['time'] as int),
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
      depth: (coordinates[2] as num).toDouble(),
      tsunamiFlag: properties['tsunami']?.toString(),
      alert: properties['alert'] as String?,
      url: properties['url'] as String? ?? '',
    );
  }

  /// Check if earthquake could be tsunamigenic
  bool get isTsunamigenic {
    // Criteria: underwater (depth < 100km) and magnitude >= 6.5
    return depth < 100 && magnitude >= 6.5;
  }

  /// Check if this is a significant earthquake
  bool get isSignificant => magnitude >= 5.0;

  /// Get alert level based on magnitude
  String get alertLevel {
    if (magnitude >= 7.0) return 'emergency';
    if (magnitude >= 6.0) return 'advisory';
    return 'none';
  }

  /// Get alert color based on magnitude
  Color get alertColor {
    if (magnitude >= AppConstants.emergencyMagnitude) return AppTheme.alertRed;
    if (magnitude >= AppConstants.advisoryMagnitude) return AppTheme.alertOrange;
    if (magnitude >= 5.5) return AppTheme.alertYellow;
    return AppTheme.alertGreen;
  }

  /// Get severity text
  String get severityText {
    if (magnitude >= 8.0) return 'Great';
    if (magnitude >= 7.0) return 'Major';
    if (magnitude >= 6.0) return 'Strong';
    if (magnitude >= 5.0) return 'Moderate';
    return 'Light';
  }

  /// Tsunami risk (0 = no, 1 = possible)
  int get tsunamiRisk {
    if (isTsunamigenic) return 1;
    return tsunamiFlag == '1' ? 1 : 0;
  }

  /// Distance from Sri Lanka (as a getter)
  double get distanceFromSriLanka {
    const sriLankaLat = 7.8731;
    const sriLankaLng = 80.7718;
    return _calculateDistance(latitude, longitude, sriLankaLat, sriLankaLng);
  }

  /// Calculate distance between two points (km) using Haversine formula
  static double _calculateDistance(
    double lat1, double lon1, double lat2, double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * 3.14159265359 / 180;

  /// Human-readable time ago
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'magnitude': magnitude,
    'place': place,
    'time': time.millisecondsSinceEpoch,
    'latitude': latitude,
    'longitude': longitude,
    'depth': depth,
    'tsunamiFlag': tsunamiFlag,
    'alert': alert,
    'url': url,
  };

  @override
  String toString() => 'Earthquake(M$magnitude at $place)';
}
