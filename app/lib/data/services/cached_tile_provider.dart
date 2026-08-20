import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';

/// Basemap tile provider that caches tiles on disk and falls back to a second
/// tile server when the primary one cannot be reached.
///
/// Why this exists: some Wi‑Fi networks block or fail to resolve a single tile
/// host (commonly tile.openstreetmap.org) while mobile data works fine, leaving
/// the map blank. Two defences address that:
///   1. Every fetched tile is cached to disk. A map opened once on any network
///      keeps rendering later on a restrictive network or fully offline, which
///      is exactly when an evacuee needs it.
///   2. A [TileLayer.fallbackUrl] points at an independent CDN, so a single
///      blocked host does not leave the map blank on a first visit.
class CachedTileProvider extends TileProvider {
  CachedTileProvider({super.headers, BaseCacheManager? cacheManager})
      : _cache = cacheManager ?? DefaultCacheManager();

  final BaseCacheManager _cache;

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return _CachedTileImage(
      url: getTileUrl(coordinates, options),
      fallbackUrl: getTileFallbackUrl(coordinates, options),
      headers: headers,
      cache: _cache,
    );
  }
}

@immutable
class _CachedTileImage extends ImageProvider<_CachedTileImage> {
  const _CachedTileImage({
    required this.url,
    required this.fallbackUrl,
    required this.headers,
    required this.cache,
  });

  final String url;
  final String? fallbackUrl;
  final Map<String, String> headers;
  final BaseCacheManager cache;

  @override
  Future<_CachedTileImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<_CachedTileImage>(this);

  @override
  ImageStreamCompleter loadImage(
    _CachedTileImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _load(decode),
      scale: 1,
      debugLabel: url,
    );
  }

  Future<Codec> _load(
    ImageDecoderCallback decode, {
    bool useFallback = false,
  }) async {
    final target = useFallback ? (fallbackUrl ?? '') : url;
    try {
      final file = await cache.getSingleFile(target, headers: headers);
      final bytes = await file.readAsBytes();
      return decode(await ImmutableBuffer.fromUint8List(bytes));
    } catch (_) {
      // On any failure (blocked host, DNS, decode), try the independent
      // fallback server once before giving up.
      if (useFallback || fallbackUrl == null) rethrow;
      return _load(decode, useFallback: true);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _CachedTileImage &&
          url == other.url &&
          fallbackUrl == other.fallbackUrl);

  @override
  int get hashCode => Object.hash(url, fallbackUrl);
}
