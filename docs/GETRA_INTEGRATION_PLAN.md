# GETRA × TsunamiSense Integration Plan

**Goal:** Turn GETRA (a DMC-facing decision-support tool) into a public-facing, offline-capable preparedness and evacuation app for coastal populations, by extending the existing **TsunamiSense** Flutter app rather than building a new one.

**Decided scope and approach (from planning session, 2026-06-27):**
- **Build on top of TsunamiSense** (Flutter, already scaffolds Android + iOS + Web from one codebase). Do not create a separate app.
- **Data delivery:** Backend API + on-device offline cache (Hive).
- **District scope:** All three districts (Galle, Matara, Tangalle), phased.
- **Shelter gap handling:** Galle ships with full routing first. Matara and Tangalle ship map-only first (inundation polygon + classified roads + failsafe guidance), with routing added once shelters are sourced.

**Resolved technical decisions (2026-06-27):**
- **Hosting:** FastAPI as a Docker Space on Hugging Face, a separate Space from the existing Streamlit demo. Free CPU tier, same workflow as `deploy/`. Cold-start sleep is acceptable because the offline cache, not the API, is the safety-critical path.
- **Backend repo:** new `GETRA/backend/` folder inside the GETRA repo (reuses `src/` + models + data), leaving `deploy/` untouched. The Flutter app remains its own repo.
- **Routing engine:** reuse the deploy implementation (`find_evacuation_route`, `find_nearest_node`, strategy-weighted Dijkstra, multi-shelter snap), **extracted into `GETRA/src/`** as a framework-agnostic module that both the Streamlit demo and the backend import (cleaner than copying into `backend/`). The single-source-from-all-shelters Dijkstra doubles as the evac-basin precompute.
- **Road classification: GROUND TRUTH, all three districts.** Use the `edge_labels` arrays (inundation-derived at 0.5 m depth) directly, not GNN predictions. This is the "Ground Truth" option already in the deploy app ("100% accurate"). Verified present for all three: Galle 3377 edges (25.6% unsafe), Matara 7994 (21.2%), Tangalle 1238 (16.9%). Consequence: the road-safety layer is maximally accurate in **all three** districts, so the earlier cross-region accuracy caveat (F1 ≈ 0.55) no longer applies to the shipped product. The GNN models are not in the shipped classification path; they are the research contribution and the engine for extending to future cities that lack inundation simulations.
- **Backend stays lightweight.** Ground-truth routing needs only `networkx`, `shapely`, `numpy`, `pandas`, `fastapi`/`uvicorn`. No `torch`, PyTorch Geometric, or `gensim` in the public backend (those stay in the research/DMC Streamlit app). Smaller image, faster cold starts.
- **App identity:** "TsunamiSense, powered by GETRA." Keep package `tsunamisense_app` and display name TsunamiSense; add "Powered by GETRA" on splash + About screen.

---

## 1. Why build on TsunamiSense (not a new app)

The TsunamiSense scaffold is almost purpose-built for this:

- **Cross-platform from one codebase** (Flutter): covers the mobile + web goal with no duplication.
- **The five screens already match a preparedness-first framing:** `learn` (education), `prepare` (checklist), `alerts` (earthquake-magnitude driven `AlertLevel`: none / advisory / warning / emergency), `map` (GPS + safe zones), `settings`.
- **Dependencies are already correct:** `flutter_map` (renders the same GeoJSON family as GETRA's Folium output), `geolocator` (GPS), `hive` + `shared_preferences` (offline cache), `firebase_messaging` + `flutter_local_notifications` (alert push), `pdf` + `printing` (printable evacuation maps), `connectivity_plus` (offline detection).
- **Integration points are already stubbed:**
  - `assets/geojson/` exists and is empty, declared in `pubspec.yaml`.
  - `map_screen.dart:137` has a hardcoded sample inundation polygon commented "would be real GeoJSON data".
  - `map_screen.dart:450` `_isInDangerZone()` is a crude lat/lng bounding box commented "would use actual GeoJSON polygon containment".
  - `map_screen.dart:364` has `// TODO: Open navigation` and a "Navigation coming soon!" placeholder.
  - `SafeZone.fromGeoJson()` factory already exists for shelter loading.
- **Early scaffold, no legacy to fight:** single commit, empty asset folders, demo data only.

**Relationship:** TsunamiSense is the public shell (education, preparedness, alerts, map UI). GETRA is the brain (inundation polygons, road-level safe/unsafe classification, shelters, routing).

---

## 2. Data inventory and gaps (verified 2026-06-27)

| Asset | Galle | Matara | Tangalle |
|---|---|---|---|
| Inundation polygon | `data/zones/inundation_zones.shp` (+ `outputs/inundation_zones.geojson`) | `data/zones/matara_inundation_zones.shp` | `data/zones/tangalle_inundation_zones.shp` |
| Road graph (geometry + 23 edge features) | `data/processed/galle_graph_data.pkl` | `data/processed/matara_graph_data.pkl` | `data/processed/tangalle_graph_data.pkl` |
| Safe/unsafe road classification | **Ground truth** (`edge_labels`, 25.6% unsafe) | **Ground truth** (`edge_labels`, 21.2% unsafe) | **Ground truth** (`edge_labels`, 16.9% unsafe) |
| Shelters | 100 (77 DMC + 23 literature), Galle only | **None** | **None** |
| Routing | Working in `GETRA/deploy/app.py` | Not built | Not built |

**One blocker remains for full three-district routing (GETRA/data side, not the app):**

1. **No shelters for Matara/Tangalle.** All 100 shelter records are Galle-district. Routing "to nearest safe shelter" is impossible without destination shelters. Resolution deferred to Phase 3.

~~2. Weak cross-region accuracy.~~ **Resolved by the ground-truth decision.** Because road safety is taken from `edge_labels` (inundation-derived) rather than GNN predictions, the road-classification layer is maximally accurate in all three districts. The F1 ≈ 0.55 cross-region figure now matters only for the research/extensibility claim (predicting safety in cities without inundation simulations), not for the shipped three-district product.

**Data hygiene note:** the CuttingEdge '26 slides cite "156 shelters"; the verified metadata count is 100 (77 DMC + 23 literature). Reconcile before any public claim. Coordinate systems already match (GETRA exports WGS84 / EPSG:4326; `flutter_map` uses WGS84 `LatLng`), so no reprojection is needed.

---

## 3. Target architecture

```
  BUILD TIME (GETRA, Python, offline)
  ───────────────────────────────────
  graph .pkl + model  ─►  per-edge safe/unsafe  ─►  roads.geojson
  inundation .shp     ─►  reproject + simplify  ─►  inundation.geojson
  shelter CSVs        ─►  normalise             ─►  shelters.geojson
  roads + shelters    ─►  multi-source Dijkstra ─►  evac_basin.json (nearest shelter + safest path per edge)
                                                     │
                                                     ▼
  RUNTIME BACKEND (FastAPI, Python)                 serves static GeoJSON + on-demand /route
  ───────────────────────────────────
  /districts · /{d}/roads · /{d}/inundation · /{d}/shelters · /{d}/route · /{d}/evac_basin · /version

                                                     │  HTTP (when online)
                                                     ▼
  CLIENT (TsunamiSense, Flutter)
  ───────────────────────────────────
  Services (Road/Inundation/Shelter/Route) ─► Hive cache (per district + version)
        │                                          │
        │  online: live /route                     │  offline: snap GPS to nearest edge,
        ▼                                          ▼   trace cached evac_basin → no network needed
  Map layers (polygon, red/green roads, shelters, route) + turn guidance + failsafe
```

**Design principle:** the heavy GNN work stays server-side at build time. The phone carries only the answers (classified roads + precomputed evacuation basins), so routing works fully offline during an actual event when networks fail.

---

## 4. Backend API specification (FastAPI)

| Method | Endpoint | Returns |
|---|---|---|
| GET | `/version` | data version hash + per-district versions (drives cache refresh) |
| GET | `/districts` | registry: id, name, bounds, capabilities (`map_only` vs `routing`), data version |
| GET | `/districts/{id}/inundation` | inundation polygon GeoJSON |
| GET | `/districts/{id}/roads` | classified road segments GeoJSON (safe/unsafe + confidence) |
| GET | `/districts/{id}/shelters` | shelters GeoJSON (Galle only initially) |
| GET | `/districts/{id}/evac_basin` | precomputed nearest-shelter + safest-path per edge (offline payload; routing districts only) |
| GET | `/districts/{id}/route?lat&lng&strategy=safest\|shortest\|balanced` | computed route GeoJSON + metrics (server-side Dijkstra, reuses GETRA) |

- Reuse `GETRA/deploy/src/` (models, graph_utils, shelters) for the route computation logic.
- Serve precomputed GeoJSON as static files; compute `/route` on demand.
- **Hosting (decided):** Docker Space on Hugging Face, separate from the Streamlit demo. Change the container CMD from Streamlit to `uvicorn`, expose 7860. Optionally split the static-GeoJSON tier onto always-on cheap hosting (GitHub Pages / release assets) later if cold starts ever matter; they do not for the offline-first design.

---

## 5. Data contracts (GeoJSON / JSON schemas)

**roads.geojson** — `FeatureCollection` of `LineString`, properties:
`{ edge_id, safety: "safe"|"unsafe", confidence: 0..1, road_type, district }`

**shelters.geojson** — `FeatureCollection` of `Point`, properties (aligns with existing `SafeZone.fromGeoJson`):
`{ id, name, type, elevation, capacity, accessible, source: "dmc"|"literature", confidence }`

**inundation.geojson** — `FeatureCollection` of `Polygon` (depth ≥ 0.5 m zone), properties: `{ district, depth_threshold_m }`

**evac_basin.json** — map of `edge_id → { nearest_shelter_id, path: [edge_id...], distance_m, safety_score }`

---

## 6. Phased roadmap

> **Phase 1 status (2026-06-27): Galle end-to-end BUILT and statically validated.**
> 1A export pipeline (`GETRA/src/routing.py`, `GETRA/scripts/export_app_data.py`) run and verified (3377 roads, 100 shelters, 2856 nodes, 100% basin coverage, correct shortest→safest trend). 1B backend (`GETRA/backend/`, FastAPI) smoke-tested, all endpoints pass, `/route` mirrors the basin. 1C Flutter integration done: new models/utils/`GetraService` (Hive cache)/`GetraProvider`, wired into `main.dart`, and `map_screen.dart` rewritten with real inundation/road/shelter layers + routing UI + offline trace + failsafe. `flutter analyze` reports 0 errors / 0 warnings in the new code. **Pending: on-device/emulator runtime testing (GPS, tiles, UI) and live deployment of the backend to Hugging Face.**
>
> **Running Phase 1 locally**
> 1. Backend: `cd GETRA/backend && .venv/bin/uvicorn main:app --port 8000` (data already exported under `backend/data`). Re-export with `GETRA/venv/bin/python scripts/export_app_data.py` if labels change.
> 2. App: set `ApiConstants.getraBaseUrl` for your target (Android emulator `http://10.0.2.2:8000`, iOS sim/web `http://localhost:8000`, real device `http://<host-ip>:8000`), then `flutter run` in `tsunamisense_app/`. First launch needs network to cache; afterwards the map and routing work offline.
> 3. Never run `pip` via `GETRA/venv` (it writes into the protected 4.2 folder). Use `GETRA/backend/.venv`.


### Phase 0 — Foundations
- [ ] Choose backend hosting target and create the FastAPI service skeleton.
- [ ] Define data version scheme (hash per district dataset).
- [ ] Decide repo layout for the backend (new repo vs `GETRA/backend/`).
- [ ] Reconcile shelter count (100 vs 156) and lock authoritative figures.

### Phase 1 — Galle, full routing, end-to-end (production quality)
**1A. GETRA export + precompute scripts** (`GETRA/scripts/export_app_data.py`)
- [ ] Load Galle graph + best routing model; export `roads.geojson` with per-edge safe/unsafe + confidence.
- [ ] Reproject + simplify Galle inundation shapefile to `inundation.geojson` (or reuse `outputs/inundation_zones.geojson`).
- [ ] Normalise DMC + literature shelters to `shelters.geojson`.
- [ ] Multi-source Dijkstra from all shelters → `evac_basin.json`.
- [ ] Validate: every edge resolves to a shelter; route metrics match GETRA's existing numbers.

**1B. Backend**
- [ ] Implement `/version`, `/districts`, and all Galle `/{id}/...` endpoints.
- [ ] Implement `/route` reusing GETRA deploy routing.
- [ ] Deploy and smoke-test.

**1C. Flutter integration**
- [ ] Add services: `RoadService`, `InundationService`, `RouteService` (mirror existing `SafeZoneService`).
- [ ] Hive boxes for per-district GeoJSON + evac basin + version; refresh-on-online logic.
- [ ] Replace hardcoded polygon (`map_screen.dart:137`) with loaded inundation GeoJSON.
- [ ] Replace bounding-box `_isInDangerZone` (`map_screen.dart:450`) with real point-in-polygon (ray casting).
- [ ] Render classified roads layer (green safe / red unsafe).
- [ ] Generalise Galle-only `AppConstants` into a multi-district registry.
- [ ] Fill `// TODO: Open navigation` (`map_screen.dart:364`): online → call `/route`; offline → snap GPS to nearest edge + trace cached basin.
- [ ] Route display: polyline + metrics + arrow/turn guidance; always-present failsafe ("move inland and uphill") when GPS/data unavailable.

**Definition of done:** From a Galle GPS point, the app shows the inundation zone, classified roads, nearest shelter, and a safe route, both online and in airplane mode.

### Phase 2 — Matara + Tangalle, map-only
- [ ] Export both districts' `roads.geojson` from their ground-truth `edge_labels` (same export script as Phase 1A, maximally accurate, no inference needed).
- [ ] Export both inundation polygons to GeoJSON.
- [ ] Add both as `map_only` districts in the registry (accurate hazard map, but no shelters yet so no routing).
- [ ] UI: show inundation + classified roads + a "routing coming soon (shelters being sourced)" banner and the failsafe guidance. No accuracy caveat needed; the hazard map is ground truth.

**Definition of done:** All three districts are visible and explorable with accurate ground-truth hazard layers; Matara/Tangalle clearly marked as routing-pending.

### Phase 3 — Matara + Tangalle, full routing
- [ ] Source shelters for both districts (DMC lists + OSM extraction of schools/temples/high-ground, then verify). **This is the only real blocker for Matara/Tangalle routing**, since road classification is already ground-truth accurate.
- [ ] Precompute evac basins; flip both districts to `routing` capability.
- [ ] (Research track, not required for the shipped app) Fine-tune with 10–20% local labels to lift GNN cross-region accuracy for future cities without inundation simulations; document the lift.

### Phase 4 — Public-readiness hardening
- [ ] Localisation: Sinhala + Tamil + English, including voice prompts for the alert flow.
- [ ] Pedestrian-weighted routing (most evacuation in the warning window is on foot).
- [ ] Alert integration: tie `AlertLevel` to official DMC / cell-broadcast warnings to auto-activate evacuation mode.
- [ ] Printable evacuation maps per Grama Niladhari division (reuse `pdf` + `printing`).
- [ ] Accessibility pass (elderly / low-literacy / one-tap evacuation).
- [ ] Testing: integration tests for offline routing, point-in-polygon, cache refresh; manual UI tests across platforms.

---

## 7. Risks, caveats, and responsibilities

- **Life-safety liability.** A wrong turn in a planner's tool wastes time; in a public app it risks a life. Public release realistically needs DMC validation/endorsement, conservative labelling (err toward marking marginal roads unsafe), visible disclaimers, and authoritative-only shelters where possible.
- **Single inundation scenario.** Labels derive from one modelled scenario at a 0.5 m depth threshold. State the assumed scenario in the UI; do not imply multi-magnitude coverage.
- **Ground truth means the road layer is the modelled hazard, faithfully.** Road safety is taken directly from the inundation-derived `edge_labels`, so all three districts' road layers are equally and maximally accurate. The honest limitation is upstream: the labels reflect one modelled inundation scenario at a 0.5 m depth threshold, not every possible tsunami magnitude. State the assumed scenario in the UI.
- **Offline is the priority path.** Networks congest or fail during disasters. The cached evac-basin path must always be sufficient to route without a server; the live `/route` API is a convenience for online use, not the safety-critical path.
- **Never over-promise live behaviour.** Debris, collapsed roads, and crowd dynamics are not modelled. Frame the app as guidance toward official shelters, not a guarantee.

---

## 8. Out of scope (for now)
- Crowdsourced road-blockage reporting.
- SMS / USSD fallback for feature phones (consider in a later wave).
- Multi-scenario inundation modelling.
- Real-time sensor integration (GETRA deliberately uses static data only).

---

## 9. Open questions

**Resolved (2026-06-27):**
1. ~~Backend hosting target.~~ → FastAPI Docker Space on Hugging Face, separate from the Streamlit demo.
2. ~~Routing engine.~~ → Reuse the deploy routing, refactored into a shared module.
3. ~~Backend repo location.~~ → New `GETRA/backend/` folder inside the GETRA repo.
4. ~~App identity.~~ → "TsunamiSense, powered by GETRA."

5. ~~Road classification model.~~ → Ground truth (`edge_labels`) for all three districts; no GNN in the shipped classification path.
6. ~~Extract routing into `src/` vs copy into `backend/`.~~ → Extract into `GETRA/src/`.

**Still open:** none blocking. Minor items surface during Phase 1A (e.g. exact GeoJSON simplification tolerance for mobile payload size).

---

*Prepared 2026-06-27. Source projects: `IPD Test 4.3/GETRA` (engine) and `IPD TsunamiSense Test 4/tsunamisense_app` (shell).*
