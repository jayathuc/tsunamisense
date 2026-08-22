---
title: GETRA API
emoji: 🌊
colorFrom: blue
colorTo: indigo
sdk: docker
app_port: 7860
pinned: false
---

# GETRA API (TsunamiSense engine)

Lightweight FastAPI backend that serves precomputed GETRA evacuation data to the
TsunamiSense public app. Routing is done by snapping a GPS point to the nearest
road node and tracing the precomputed evacuation basin, so the service needs no
model, PyTorch, or graph library at runtime.

## Data

All served data lives under `data/`, produced offline from the GETRA project root:

```bash
venv/bin/python scripts/export_app_data.py --district galle      # or: all
```

This writes `data/districts.json` and `data/<district>/{roads,inundation,shelters}.geojson`,
`nodes.json`, `evac_basin.json`, `meta.json`.

## Run locally

```bash
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

## Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/` | health + district ids |
| GET | `/version` | global + per-district data versions (drives client cache refresh) |
| GET | `/districts` | full registry |
| GET | `/districts/{id}/meta` | district metadata |
| GET | `/districts/{id}/roads` | classified road segments (GeoJSON) |
| GET | `/districts/{id}/inundation` | inundation polygon (GeoJSON) |
| GET | `/districts/{id}/shelters` | shelters (GeoJSON) |
| GET | `/districts/{id}/nodes` | node id → [lon, lat] (for offline route tracing) |
| GET | `/districts/{id}/evac_basin` | per-strategy nearest-shelter route tree (offline payload) |
| POST | `/districts/{id}/route` | live route trace to nearest shelter (preferred) |
| GET | `/districts/{id}/route?lat=&lng=&strategy=&set=` | same, kept for compatibility |

Prefer the POST form. It takes the same parameters as a JSON body:

```json
{ "lat": 6.0335, "lng": 80.2170, "strategy": "safest", "set": "dmc" }
```

Coordinates in a query string end up in access logs and proxy caches; in a body
they do not. The GET form remains for compatibility and quick manual testing.

`strategy` ∈ `shortest | balanced | safest` (default `safest`).

`set` selects which shelter sources to route to, and must be one of the district's
precomputed basin keys: Galle has `dmc` and `dmc+literature`; Matara and Tangalle have
`osm` only. When omitted it defaults to `dmc` where available, otherwise the district's
single set, matching the app's default in `district_data.dart`.

## Deploy (Hugging Face Docker Space)

Push this `backend/` folder (including `data/`) as a Docker Space. The provided
`Dockerfile` runs uvicorn on port 7860. Kept separate from the existing Streamlit
research demo.
