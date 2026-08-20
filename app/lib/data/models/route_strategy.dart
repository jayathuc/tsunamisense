import 'package:flutter/material.dart';

/// Evacuation routing strategy. Mirrors the GETRA backend strategies.
enum RouteStrategy { shortest, balanced, safest }

extension RouteStrategyX on RouteStrategy {
  /// Backend id used in `/route?strategy=`.
  String get id => switch (this) {
        RouteStrategy.shortest => 'shortest',
        RouteStrategy.balanced => 'balanced',
        RouteStrategy.safest => 'safest',
      };

  String get label => switch (this) {
        RouteStrategy.shortest => 'Shortest',
        RouteStrategy.balanced => 'Balanced',
        RouteStrategy.safest => 'Safest',
      };

  String get description => switch (this) {
        RouteStrategy.shortest =>
          'Fastest route by distance. May pass through flood-prone roads.',
        RouteStrategy.balanced =>
          'A safer route that does not go too far out of the way.',
        RouteStrategy.safest =>
          'Avoids flood-prone roads wherever a safer path exists.',
      };

  IconData get icon => switch (this) {
        RouteStrategy.shortest => Icons.straighten,
        RouteStrategy.balanced => Icons.balance,
        RouteStrategy.safest => Icons.verified_user,
      };

  /// Colour used to draw the route line for this strategy.
  Color get color => switch (this) {
        RouteStrategy.shortest => const Color(0xFF607D8B),
        RouteStrategy.balanced => const Color(0xFF7E57C2),
        RouteStrategy.safest => const Color(0xFF1565C0),
      };

  static RouteStrategy fromId(String id) => RouteStrategy.values.firstWhere(
        (s) => s.id == id,
        orElse: () => RouteStrategy.safest,
      );
}
