import 'dart:math' as math;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../core/constants/api_constants.dart';

/// One slippy-map tile coordinate.
class _Tile {
  final int z, x, y;
  const _Tile(this.z, this.x, this.y);
}

/// Pre-downloads basemap tiles for a district's bounding box into the same
/// on-disk cache used by [CachedTileProvider], so the map renders with no
/// internet. This turns the "Offline maps" setting into a real action.
class TilePrefetchService {
  final BaseCacheManager _cache;
  bool _cancelled = false;

  TilePrefetchService({BaseCacheManager? cacheManager})
      : _cache = cacheManager ?? DefaultCacheManager();

  void cancel() => _cancelled = true;

  /// Number of tiles a [bbox] (`[minLon, minLat, maxLon, maxLat]`) covers across
  /// the zoom range, so the UI can show an estimate before downloading.
  static int estimateCount(List<double> bbox,
          {int minZoom = 11, int maxZoom = 15}) =>
      _tilesFor(bbox, minZoom, maxZoom).length;

  /// Download every tile for [bbox], reporting progress after each one. Returns
  /// true if it completed, false if cancelled. Individual tile failures are
  /// ignored so one bad fetch does not abort the whole batch.
  Future<bool> prefetch(
    List<double> bbox, {
    int minZoom = 11,
    int maxZoom = 15,
    void Function(int done, int total)? onProgress,
    Map<String, String> headers = const {},
  }) async {
    _cancelled = false;
    final tiles = _tilesFor(bbox, minZoom, maxZoom);
    final total = tiles.length;
    final subs = ApiConstants.tileSubdomains;
    var done = 0;
    for (final t in tiles) {
      if (_cancelled) return false;
      final s = subs[done % subs.length];
      final url =
          'https://$s.basemaps.cartocdn.com/light_all/${t.z}/${t.x}/${t.y}.png';
      try {
        await _cache.getSingleFile(url, headers: headers);
      } catch (_) {
        // Skip tiles that fail; the user can retry later.
      }
      done++;
      onProgress?.call(done, total);
    }
    return !_cancelled;
  }

  static List<_Tile> _tilesFor(List<double> bbox, int minZoom, int maxZoom) {
    final minLon = bbox[0], minLat = bbox[1], maxLon = bbox[2], maxLat = bbox[3];
    final out = <_Tile>[];
    for (var z = minZoom; z <= maxZoom; z++) {
      final xA = _lonToX(minLon, z), xB = _lonToX(maxLon, z);
      // y grows southward, so the larger latitude maps to the smaller y.
      final yA = _latToY(maxLat, z), yB = _latToY(minLat, z);
      for (var x = math.min(xA, xB); x <= math.max(xA, xB); x++) {
        for (var y = math.min(yA, yB); y <= math.max(yA, yB); y++) {
          out.add(_Tile(z, x, y));
        }
      }
    }
    return out;
  }

  static int _lonToX(double lon, int z) =>
      ((lon + 180.0) / 360.0 * (1 << z)).floor().clamp(0, (1 << z) - 1);

  static int _latToY(double lat, int z) {
    final rad = lat * math.pi / 180.0;
    final y = (1 - math.log(math.tan(rad) + 1 / math.cos(rad)) / math.pi) /
        2 *
        (1 << z);
    return y.floor().clamp(0, (1 << z) - 1);
  }
}
