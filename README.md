# TsunamiSense

**Learn. Prepare. Stay Safe.**

An offline-first tsunami warning and evacuation-routing app for coastal southern Sri
Lanka. It monitors Indian Ocean seismic activity in real time, and when it matters most
it routes you to shelter along roads that a machine-learning model has classified as
survivable, **with no network connection required**.

TsunamiSense is the public-facing half of **GETRA** (Graph-based Evacuation and Tsunami
Route Assessment), a BSc Computer Science final-year project at IIT Sri Lanka /
University of Westminster. GETRA performs edge-level binary classification on road
network graphs to decide which road segments are safe or unsafe during tsunami
inundation. This repository is the app that puts those results in people's hands, plus
the API that serves them.

> **This is academic research software, not an official warning system.** Shelter
> locations are reference points derived from public data and published research; they
> are not verified evacuation sites. Always follow instructions from Sri Lanka's
> Disaster Management Centre and other official authorities.

---

## Why offline-first

An evacuation app that needs a working connection during an earthquake is an evacuation
app that does not work. Mobile networks are among the first things to fail.

So the expensive part happens ahead of time. The GETRA models classify every road
segment offline, and a per-district evacuation basin, a precomputed shortest-path tree
from every intersection to its nearest shelter, is exported once under three routing
strategies. The app ships those tables as compressed assets and traces routes **on the
device**. A first launch in airplane mode still shows the map, the inundation zones, the
shelters, and a full turn-by-turn evacuation path.

The network is used only to keep that data fresh, never to produce a route.

```
GETRA models  ──▶  export_app_data.py  ──▶  backend/data/  ──▶  FastAPI  ──▶  Hive cache
(offline, once)     roads + basins          versioned JSON      (updates)     on device
                                                    │                              │
                                                    └────▶ gzipped app assets ─────┤
                                                           (offline seed)          ▼
                                                                         on-device route trace
```

---

## Coverage

Three coastal areas of southern Sri Lanka. Galle is the primary study area; Matara and
Tangalle were used to test whether the approach generalises to unseen regions.

| Area | Road segments | Classified unsafe | Intersections | Shelters | Shelter sources |
|---|---|---|---|---|---|
| Galle | 3377 | 865 | 2856 | 100 | DMC-verified, research-supported |
| Matara | 7994 | 1697 | 6728 | 30 | OpenStreetMap |
| Tangalle | 1238 | 209 | 1042 | 26 | OpenStreetMap |

Tangalle is a town in Hambantota District; the other two are district capitals. Only
Galle currently routes to DMC-verified shelters. Matara and Tangalle route to shelters
derived from OpenStreetMap, which is why the OSM shelter layer must be enabled to get
routes there.

---

## Features

**Monitoring and alerting**
- Live earthquake feed from the USGS FDSN API, filtered to the Indian Ocean basin
  (latitude −10 to 30, longitude 50 to 105) at magnitude 5.0 and above
- Graduated alert levels: advisory at M6.0, emergency at M7.0
- Official tsunami bulletin polling via GDACS
- Local notifications, magnitude filtering, and a per-earthquake detail sheet

**Evacuation**
- On-device route tracing to the nearest shelter, fully offline
- Three strategies: shortest, balanced, and safest, which trades distance for fewer
  unsafe segments
- Emergency mode forces the safest strategy and DMC-verified shelters only, and jumps
  straight to the map
- Classified road overlay, inundation polygons, and toggleable shelter sources
- A failsafe instruction ("move inland and uphill") whenever no route can be computed,
  so the app never leaves you with nothing

**Preparedness**
- 15 lessons with 21 quiz questions
- Emergency checklist with persistent state, sharing, and export
- Offline map-tile prefetch and caching

**Localisation**
- English, Sinhala, and Tamil, with all 193 strings translated in every language

---

## Repository layout

```
app/         Flutter application (Dart, ~9.7k lines across 41 files)
backend/     FastAPI service + Dockerfile serving the precomputed GETRA data
tool/        sync_app_data.sh, regenerates the app's offline seed from backend/data
docs/        screenshots and supporting notes
```

The app is built around Provider for state, Hive for the offline data cache,
SharedPreferences for settings, and flutter_map with Carto CDN tiles (OpenStreetMap as
fallback). Source is split into `core/`, `data/`, `presentation/`, `providers/`, `l10n/`.

---

## Running it

### App

Requires Flutter with Dart SDK 3.8.1 or newer.

```bash
cd app
flutter pub get
flutter run
```

No backend needed. The district data ships with the app, so it works immediately,
online or off.

### Backend

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

Or with Docker:

```bash
cd backend
docker build -t getra-api .
docker run -p 7860:7860 getra-api
```

To point the app at a local instance, change `getraBaseUrl` in
`app/lib/core/constants/api_constants.dart`. Documented alternatives for the Android
emulator, iOS simulator, and physical devices are in the comments there.

After regenerating `backend/data`, refresh the app's bundled copy:

```bash
./tool/sync_app_data.sh
```

### API

| Method | Path | Description |
|---|---|---|
| GET | `/` | health check and district ids |
| GET | `/version` | global and per-district data versions, drives cache refresh |
| GET | `/districts` | full registry |
| GET | `/districts/{id}/roads` | classified road segments (GeoJSON) |
| GET | `/districts/{id}/inundation` | inundation polygons (GeoJSON) |
| GET | `/districts/{id}/shelters` | shelters (GeoJSON) |
| GET | `/districts/{id}/nodes` | node id to coordinate map |
| GET | `/districts/{id}/evac_basin` | precomputed route trees |
| GET | `/districts/{id}/route` | server-side route trace |

The service holds no model at runtime; it serves precomputed data and traces routes by
walking the basin, so it needs neither PyTorch nor a graph library.

---

## Screenshots

See [`docs/screenshots/`](docs/screenshots/).

---

## Limitations and future work

Being straight about what this does not yet do:

- **Shelter data needs official verification.** Coordinates are reference points from
  public datasets and research literature, not confirmed evacuation sites.
- **Coverage is three areas, not the whole coast.** Extending it requires running the
  GETRA export pipeline for each new district.
- **Data updates are not self-service.** The version-hash mechanism means clients pick
  up new data automatically, but publishing that data is currently a developer task:
  every endpoint is read-only, and the container bakes its data in at build time.
  Because road safety is derived from the inundation extent, a revised inundation map
  changes the classifications, the routing graph, and the basins together, so it needs a
  full pipeline run rather than a file swap. An authenticated ingestion path that lets
  the DMC upload new inundation data and trigger a re-export is the single most valuable
  next step.
- **Push notifications are scaffolded but not wired up.** Firebase dependencies are
  present; alerts currently fire locally rather than from a server.

---

## Acknowledgements

Earthquake data from the [USGS](https://earthquake.usgs.gov/); tsunami bulletins from
[GDACS](https://www.gdacs.org/); base map data from
[OpenStreetMap](https://www.openstreetmap.org/copyright) contributors, tiles by
[CARTO](https://carto.com/).

Built by [Jayathu Chamikara](https://github.com/jayathuc).
