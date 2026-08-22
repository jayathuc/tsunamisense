import 'package:geolocator/geolocator.dart';

/// Why a location request did not return a usable position.
enum LocationFailure {
  /// Device location (GPS) is switched off system-wide.
  servicesOff,

  /// Permission refused for this request only; asking again may succeed.
  denied,

  /// Permission refused permanently; only the system settings screen can undo it.
  deniedForever,

  /// Permission granted but no fix could be obtained in time.
  unavailable,
}

/// Outcome of a location request: either a position, or a reason it failed.
class LocationResult {
  final Position? position;
  final LocationFailure? failure;

  /// True when [position] came from the OS cache rather than a fresh fix, so
  /// it may be stale or coarse.
  final bool isApproximate;

  const LocationResult.success(this.position, {this.isApproximate = false})
      : failure = null;
  const LocationResult.failed(this.failure)
      : position = null,
        isApproximate = false;

  bool get ok => position != null;
}

/// Single place where the app asks for the user's position.
///
/// Both the manual "my location" button and the automatic emergency flow go
/// through here, so permission handling and timeouts cannot drift apart between
/// them.
class LocationService {
  /// How long to wait for a precise fix before falling back.
  ///
  /// Deliberately short: during an evacuation a coarse position now beats an
  /// exact one that never arrives. Without a limit, getCurrentPosition can wait
  /// indefinitely on a weak signal.
  static const Duration fixTimeout = Duration(seconds: 10);

  /// Resolve the user's position, falling back to the last known fix.
  static Future<LocationResult> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const LocationResult.failed(LocationFailure.servicesOff);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return const LocationResult.failed(LocationFailure.deniedForever);
    }
    if (permission == LocationPermission.denied) {
      return const LocationResult.failed(LocationFailure.denied);
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: fixTimeout,
      );
      return LocationResult.success(pos);
    } catch (_) {
      // Timed out or the fix failed. A cached position still lets the user get
      // a route, which is far better than nothing in an emergency.
      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          return LocationResult.success(last, isApproximate: true);
        }
      } catch (_) {
        // fall through
      }
      return const LocationResult.failed(LocationFailure.unavailable);
    }
  }

  /// Continuous updates, so a route can follow the user as they move.
  static Stream<Position> watch({int distanceFilterMeters = 15}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }

  /// Open the OS settings page so the user can undo a permanent denial.
  static Future<bool> openSettings() => Geolocator.openAppSettings();
}
