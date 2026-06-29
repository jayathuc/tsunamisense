/// API endpoints and URLs used in the application
class ApiConstants {
  // USGS Earthquake API
  static const String usgsBaseUrl = 'https://earthquake.usgs.gov';
  static const String usgsEarthquakeEndpoint = '/fdsnws/event/1/query';
  
  /// Get USGS earthquake query URL for Indian Ocean region
  static String getUsgsEarthquakeUrl({
    double minMagnitude = 5.0,
    int limit = 20,
  }) {
    return '$usgsBaseUrl$usgsEarthquakeEndpoint'
        '?format=geojson'
        '&minmagnitude=$minMagnitude'
        '&minlatitude=-10'
        '&maxlatitude=30'
        '&minlongitude=50'
        '&maxlongitude=105'
        '&orderby=time'
        '&limit=$limit';
  }

  // USGS Real-time Feeds (alternative)
  static const String usgsRealtimeFeedAll = 
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson';
  static const String usgsRealtimeFeedSignificant = 
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_week.geojson';
  static const String usgsRealtimeFeed4_5Plus = 
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_day.geojson';

  // GDACS (Global Disaster Alerting Coordination System)
  static const String gdacsRssFeed = 'https://www.gdacs.org/xml/rss.xml';
  static const String gdacsCapFeed = 'https://www.gdacs.org/xml/gdacs_cap.xml';

  // Tsunami.gov (NOAA)
  static const String tsunamiGovUrl = 'https://www.tsunami.gov/';

  // Basemap tiles.
  // Primary: Carto basemaps, served via the Fastly CDN with rotating subdomains
  // (a–d). A CDN with many anycast IPs is far less likely to be blocked or
  // unresolvable on a restrictive Wi‑Fi network than the single OpenStreetMap
  // tile host, which is the usual cause of "map loads on mobile data but not
  // Wi‑Fi". OSM is kept only as a last-resort fallback.
  static const List<String> tileSubdomains = ['a', 'b', 'c', 'd'];
  static const String cartoLightTileUrl =
      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
  static const String cartoDarkTileUrl =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';

  // Fallback: standard OpenStreetMap tiles (single host, no subdomain).
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Firebase (to be configured)
  // These will be set up when Firebase project is created
  static const String firebaseProjectId = 'tsunamisense-app';

  // TsunamiSense Backend
  // Android emulator: 'http://10.0.2.2:3000'
  // iOS simulator: 'http://localhost:3000'
  // Real device on same WiFi: 'http://<HOST_IP>:3000'
  static const String backendBaseUrl = 'http://10.0.2.2:3000';
  static const String safeZonesEndpoint = '/api/safezones';
  static const String safeZonesNearbyEndpoint = '/api/safezones/nearby';
  static const String safeZonesNearestEndpoint = '/api/safezones/nearest';

  // GETRA Evacuation API (this project's FastAPI backend; see GETRA/backend)
  // Live deployment (works on emulator, phone, and web with no local server):
  static const String getraBaseUrl = 'https://jayathuc-getra-api.hf.space';
  // Local alternatives for development:
  //   Android emulator -> host machine: 'http://10.0.2.2:8000'
  //   iOS sim / web                   : 'http://localhost:8000'
  //   real device on same WiFi        : 'http://<host-ip>:8000'
}
