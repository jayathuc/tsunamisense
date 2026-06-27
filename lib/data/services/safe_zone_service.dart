import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/safe_zone.dart';
import '../../core/constants/api_constants.dart';

/// Service for fetching safe zone data from TsunamiSense backend
class SafeZoneService {
  final http.Client _client;

  SafeZoneService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch all safe zones from the backend
  Future<List<SafeZone>> fetchAllSafeZones() async {
    final response = await _client
        .get(
          Uri.parse('${ApiConstants.backendBaseUrl}${ApiConstants.safeZonesEndpoint}'),
          headers: {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>;
      return list
          .map((e) => SafeZone.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw SafeZoneServiceException(
      'Failed to fetch safe zones: ${response.statusCode}',
    );
  }

  /// Fetch safe zones near a given location
  Future<List<SafeZone>> fetchNearbySafeZones(
    double lat,
    double lng, {
    double radius = 10,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.backendBaseUrl}${ApiConstants.safeZonesNearbyEndpoint}',
    ).replace(queryParameters: {
      'lat': '$lat',
      'lng': '$lng',
      'radius': '$radius',
    });

    final response = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>;
      return list
          .map((e) => SafeZone.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw SafeZoneServiceException(
      'Failed to fetch nearby safe zones: ${response.statusCode}',
    );
  }

  void dispose() {
    _client.close();
  }
}

/// Exception for safe zone service errors
class SafeZoneServiceException implements Exception {
  final String message;
  SafeZoneServiceException(this.message);

  @override
  String toString() => 'SafeZoneServiceException: $message';
}
