/// Safe Zone data model for evacuation points
class SafeZone {
  final String id;
  final String name;
  final String type; // 'high_ground', 'building', 'shelter'
  final double latitude;
  final double longitude;
  final double elevation; // meters above sea level
  final int? capacity;
  final bool isAccessible; // wheelchair accessible
  final String? address;
  final String? description;
  final List<String>? facilities;
  final String? source; // 'dmc' | 'literature' (GETRA shelter origin)

  SafeZone({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.elevation,
    this.capacity,
    this.isAccessible = false,
    this.address,
    this.description,
    this.facilities,
    this.source,
  });

  /// Create from GeoJSON feature
  factory SafeZone.fromGeoJson(Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>;
    final geometry = feature['geometry'] as Map<String, dynamic>;
    final coordinates = geometry['coordinates'] as List<dynamic>;

    return SafeZone(
      id: properties['id']?.toString() ?? DateTime.now().toString(),
      name: properties['name'] as String? ?? 'Safe Zone',
      type: properties['type'] as String? ?? 'high_ground',
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
      elevation: (properties['elevation'] as num?)?.toDouble() ?? 10.0,
      capacity: properties['capacity'] as int?,
      isAccessible: properties['accessible'] as bool? ?? false,
      address: properties['address'] as String?,
      description: properties['description'] as String?,
      facilities: (properties['facilities'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      source: properties['source'] as String?,
    );
  }

  /// Create from JSON map
  factory SafeZone.fromJson(Map<String, dynamic> json) {
    return SafeZone(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num).toDouble(),
      capacity: json['capacity'] as int?,
      isAccessible: json['isAccessible'] as bool? ?? false,
      address: json['address'] as String?,
      description: json['description'] as String?,
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'latitude': latitude,
    'longitude': longitude,
    'elevation': elevation,
    'capacity': capacity,
    'isAccessible': isAccessible,
    'address': address,
    'description': description,
    'facilities': facilities,
    'source': source,
  };

  /// Get icon name based on type
  String get iconName {
    switch (type.toLowerCase()) {
      case 'building':
        return 'business';
      case 'shelter':
        return 'home';
      case 'school':
        return 'school';
      case 'temple':
        return 'temple_buddhist';
      case 'hospital':
        return 'local_hospital';
      default:
        return 'terrain';
    }
  }

  /// Get type display name
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'high_ground':
        return 'High Ground';
      case 'building':
        return 'Evacuation Building';
      case 'shelter':
        return 'Emergency Shelter';
      case 'school':
        return 'School (Multi-story)';
      case 'temple':
        return 'Temple';
      case 'hospital':
        return 'Hospital';
      default:
        return type;
    }
  }

  @override
  String toString() => 'SafeZone($name, $type, ${elevation}m)';
}
