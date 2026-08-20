import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/earthquake.dart';
import '../../core/constants/api_constants.dart';

/// Service for fetching earthquake data from USGS API
class EarthquakeService {
  final http.Client _client;

  EarthquakeService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch recent earthquakes from USGS API
  /// Returns earthquakes in the Indian Ocean region with magnitude >= minMagnitude
  Future<List<Earthquake>> fetchRecentEarthquakes({
    double minMagnitude = 5.0,
    int limit = 20,
  }) async {
    try {
      final url = ApiConstants.getUsgsEarthquakeUrl(
        minMagnitude: minMagnitude,
        limit: limit,
      );

      final response = await _client.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final features = data['features'] as List<dynamic>;

        return features
            .map((f) => Earthquake.fromUsgsJson(f as Map<String, dynamic>))
            .toList();
      } else {
        throw EarthquakeServiceException(
          'Failed to fetch earthquakes: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is EarthquakeServiceException) rethrow;
      throw EarthquakeServiceException('Network error: $e');
    }
  }

  /// Fetch earthquakes from the last hour (real-time feed)
  Future<List<Earthquake>> fetchLastHourEarthquakes() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.usgsRealtimeFeedAll),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final features = data['features'] as List<dynamic>;

        // Filter for Indian Ocean region
        return features
            .map((f) => Earthquake.fromUsgsJson(f as Map<String, dynamic>))
            .where((eq) => _isInIndianOceanRegion(eq))
            .toList();
      } else {
        throw EarthquakeServiceException(
          'Failed to fetch earthquakes: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is EarthquakeServiceException) rethrow;
      throw EarthquakeServiceException('Network error: $e');
    }
  }

  /// Fetch significant earthquakes (M4.5+) from last 24 hours
  Future<List<Earthquake>> fetchSignificantEarthquakes() async {
    try {
      final response = await _client.get(
        Uri.parse(ApiConstants.usgsRealtimeFeed4_5Plus),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final features = data['features'] as List<dynamic>;

        // Filter for Indian Ocean region
        return features
            .map((f) => Earthquake.fromUsgsJson(f as Map<String, dynamic>))
            .where((eq) => _isInIndianOceanRegion(eq))
            .toList();
      } else {
        throw EarthquakeServiceException(
          'Failed to fetch earthquakes: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is EarthquakeServiceException) rethrow;
      throw EarthquakeServiceException('Network error: $e');
    }
  }

  /// Check if earthquake is in Indian Ocean region
  bool _isInIndianOceanRegion(Earthquake eq) {
    return eq.latitude >= -10 &&
        eq.latitude <= 30 &&
        eq.longitude >= 50 &&
        eq.longitude <= 100;
  }

  /// Filter earthquakes that could affect Sri Lanka
  List<Earthquake> filterForSriLanka(List<Earthquake> earthquakes) {
    return earthquakes.where((eq) {
      // Must be significant magnitude
      if (eq.magnitude < 5.0) return false;

      // Must be within reasonable distance (3000km)
      final distance = eq.distanceFromSriLanka;
      if (distance > 3000) return false;

      // For tsunamigenic potential, check if underwater
      // Approximate - depth less than 100km usually means shallow/can cause tsunami
      return true;
    }).toList();
  }

  /// Get earthquakes that warrant alerts
  List<Earthquake> getAlertableEarthquakes(List<Earthquake> earthquakes) {
    return earthquakes.where((eq) {
      // Advisory level: M6.0+
      if (eq.magnitude < 6.0) return false;

      // Must be in region that could affect Sri Lanka
      final distance = eq.distanceFromSriLanka;
      return distance <= 3000;
    }).toList();
  }

  void dispose() {
    _client.close();
  }
}

/// Exception for earthquake service errors
class EarthquakeServiceException implements Exception {
  final String message;
  EarthquakeServiceException(this.message);

  @override
  String toString() => 'EarthquakeServiceException: $message';
}
