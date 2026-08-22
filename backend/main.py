"""
GETRA public backend (TsunamiSense engine)
==========================================

Lightweight FastAPI service that exposes the precomputed GETRA evacuation data
to the TsunamiSense mobile/web app. It serves the static GeoJSON layers and runs
``/route`` by snapping a GPS point to the nearest road node and tracing the
precomputed evacuation basin, so no model, PyTorch, or graph library is needed
at runtime.

Data is produced offline by ``scripts/export_app_data.py`` into ``backend/data``.

Run locally:
    uvicorn main:app --reload --port 8000
Deploy (Hugging Face Docker Space):
    uvicorn main:app --host 0.0.0.0 --port 7860
"""

from __future__ import annotations

import json
import math
import os
from typing import Dict, Optional

from fastapi import Body, FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.responses import JSONResponse, Response

DATA_ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")
STRATEGIES = {"shortest", "balanced", "safest"}

app = FastAPI(
    title="GETRA API",
    description="Evacuation routing engine for the TsunamiSense public app.",
    version="1.0.0",
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # public read-only data; tighten per-deployment if needed
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)
# Compress the large GeoJSON / basin payloads (~9x smaller over the wire).
app.add_middleware(GZipMiddleware, minimum_size=1024)


# ---------------------------------------------------------------------------
# In-memory cache of per-district data (loaded lazily, kept for route tracing)
# ---------------------------------------------------------------------------

_registry: Optional[Dict] = None
_cache: Dict[str, Dict] = {}


def _district_dir(district: str) -> str:
    d = os.path.join(DATA_ROOT, district)
    if not os.path.isdir(d):
        raise HTTPException(status_code=404, detail=f"Unknown district '{district}'")
    return d


def _load_json(district: str, filename: str) -> Dict:
    path = os.path.join(_district_dir(district), filename)
    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail=f"{filename} not available for '{district}'")
    with open(path) as f:
        return json.load(f)


def get_registry() -> Dict:
    global _registry
    if _registry is None:
        path = os.path.join(DATA_ROOT, "districts.json")
        if not os.path.exists(path):
            raise HTTPException(status_code=503, detail="No district registry; run export_app_data.py")
        with open(path) as f:
            _registry = json.load(f)
    return _registry


def get_routing_cache(district: str) -> Dict:
    """Load and index the data needed to trace routes for a district."""
    if district in _cache:
        return _cache[district]

    nodes = _load_json(district, "nodes.json")          # {node_str: [lon, lat]}
    # {shelter_set: {strategy: {node_str: {...}}}} — the set is a sorted, '+'-joined
    # combination of the shelter sources the district has ("dmc", "dmc+literature",
    # "osm"), matching the app's basin key in district_data.dart.
    basin = _load_json(district, "evac_basin.json")
    shelters = _load_json(district, "shelters.geojson")
    roads = _load_json(district, "roads.geojson")

    shelter_by_id = {
        f["properties"]["id"]: {
            "id": f["properties"]["id"],
            "name": f["properties"]["name"],
            "coords": f["geometry"]["coordinates"],  # [lon, lat]
        }
        for f in shelters["features"]
    }
    # edge geometry lookup keyed by unordered node pair
    edge_geom: Dict = {}
    for f in roads["features"]:
        u, v = f["properties"].get("u"), f["properties"].get("v")
        if u is not None and v is not None:
            edge_geom[(u, v)] = f["geometry"]["coordinates"]
            edge_geom[(v, u)] = list(reversed(f["geometry"]["coordinates"]))

    cache = {"nodes": nodes, "basin": basin, "shelter_by_id": shelter_by_id, "edge_geom": edge_geom}
    _cache[district] = cache
    return cache


def _resolve_basin_set(basin: Dict, district: str, requested: Optional[str]) -> str:
    """Pick which shelter-set basin to trace.

    Mirrors the app's default in district_data.dart: DMC-verified shelters only
    when the district has them, otherwise every source the district does have
    (Matara and Tangalle ship OSM shelters only, so they would not route at all
    under a strict DMC-only rule).
    """
    available = sorted(basin.keys())
    if not available:
        raise HTTPException(status_code=404, detail=f"'{district}' has no routing (map-only)")
    if requested is not None:
        if requested not in basin:
            raise HTTPException(
                status_code=400,
                detail=f"unknown set '{requested}' for '{district}'; available: {available}",
            )
        return requested
    return "dmc" if "dmc" in basin else available[0]


def _haversine_m(lat1, lon1, lat2, lon2) -> float:
    r = 6371000.0
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp, dl = math.radians(lat2 - lat1), math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * r * math.asin(math.sqrt(a))


def _nearest_node(nodes: Dict, lat: float, lon: float):
    best, best_d = None, float("inf")
    for nid, (nlon, nlat) in nodes.items():
        d = _haversine_m(lat, lon, nlat, nlon)
        if d < best_d:
            best_d, best = d, nid
    return best, best_d


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@app.get("/")
def health():
    reg = get_registry()
    return {"status": "ok", "service": "GETRA API", "districts": [d["id"] for d in reg["districts"]]}


@app.get("/version")
def version():
    reg = get_registry()
    return {
        "version": reg["version"],
        "districts": {d["id"]: d["version"] for d in reg["districts"]},
    }


@app.get("/districts")
def districts():
    return get_registry()


_raw_file_cache: Dict[str, str] = {}


def _file(district: str, filename: str) -> Response:
    path = os.path.join(_district_dir(district), filename)
    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail=f"{filename} not available for '{district}'")
    content = _raw_file_cache.get(path)
    if content is None:
        with open(path) as f:
            content = f.read()
        _raw_file_cache[path] = content
    # Returned as a buffered Response so GZipMiddleware can compress it.
    return Response(content=content, media_type="application/json")


@app.get("/districts/{district}/meta")
def meta(district: str):
    return _file(district, "meta.json")


@app.get("/districts/{district}/roads")
def roads(district: str):
    return _file(district, "roads.geojson")


@app.get("/districts/{district}/inundation")
def inundation(district: str):
    return _file(district, "inundation.geojson")


@app.get("/districts/{district}/shelters")
def shelters(district: str):
    return _file(district, "shelters.geojson")


@app.get("/districts/{district}/nodes")
def nodes(district: str):
    return _file(district, "nodes.json")


@app.get("/districts/{district}/evac_basin")
def evac_basin(district: str):
    return _file(district, "evac_basin.json")


def _trace_route(district: str, lat: float, lng: float, strategy: str, set: Optional[str]):
    """Snap a GPS point to the nearest road node and trace the precomputed
    evacuation route to its nearest shelter. Mirrors the app's offline logic."""
    if strategy not in STRATEGIES:
        raise HTTPException(status_code=400, detail=f"strategy must be one of {sorted(STRATEGIES)}")

    cache = get_routing_cache(district)
    basin_set = _resolve_basin_set(cache["basin"], district, set)
    basin = cache["basin"][basin_set].get(strategy)
    if basin is None:
        raise HTTPException(
            status_code=404,
            detail=f"'{district}' set '{basin_set}' has no '{strategy}' basin",
        )

    src_node, snap_d = _nearest_node(cache["nodes"], lat, lng)
    if src_node not in basin:
        # Node sits in a component with no reachable shelter -> generic failsafe.
        return JSONResponse({
            "found": False,
            "message": "No precomputed route from here. Move inland and uphill, away from the coast.",
            "origin": [lng, lat],
            "snap_distance_m": round(snap_d),
            "set": basin_set,
        })

    # trace next-pointers to build the node path
    path_nodes = [src_node]
    cur = src_node
    guard = 0
    while basin[cur]["next"] is not None and guard < 5000:
        nxt = str(basin[cur]["next"])
        if nxt not in basin:
            break
        path_nodes.append(nxt)
        cur = nxt
        guard += 1

    info = basin[src_node]
    shelter = cache["shelter_by_id"].get(info["shelter"], {"id": info["shelter"]})

    # build route geometry following real road shapes where available
    coords = []
    for a, b in zip(path_nodes, path_nodes[1:]):
        seg = cache["edge_geom"].get((int(a), int(b)))
        if seg:
            if coords and coords[-1] == seg[0]:
                coords.extend(seg[1:])
            else:
                coords.extend(seg)
        else:
            coords.append(cache["nodes"][a])
            coords.append(cache["nodes"][b])
    if not coords:
        coords = [cache["nodes"][src_node]]
    # connect final road node to the shelter location
    if "coords" in shelter and coords[-1] != shelter["coords"]:
        coords.append(shelter["coords"])

    return {
        "found": True,
        "district": district,
        "strategy": strategy,
        "set": basin_set,
        "origin": [lng, lat],
        "snap_distance_m": round(snap_d),
        "shelter": shelter,
        "dist_m": info["dist_m"],
        "n_unsafe": info["n_unsafe"],
        "safety": info["safety"],
        "geometry": {"type": "LineString", "coordinates": coords},
    }


@app.post("/districts/{district}/route")
def route_post(
    district: str,
    body: Dict = Body(..., example={"lat": 6.0335, "lng": 80.2170, "strategy": "safest"}),
):
    """Preferred over the GET form: coordinates travel in the body rather than
    the URL, so a user's precise position does not end up in server access logs
    or proxy caches."""
    try:
        lat = float(body["lat"])
        lng = float(body["lng"])
    except (KeyError, TypeError, ValueError):
        raise HTTPException(status_code=422, detail="body must contain numeric 'lat' and 'lng'")
    if not (-90 <= lat <= 90) or not (-180 <= lng <= 180):
        raise HTTPException(status_code=422, detail="lat/lng out of range")
    return _trace_route(district, lat, lng, body.get("strategy", "safest"), body.get("set"))


@app.get("/districts/{district}/route")
def route(
    district: str,
    lat: float = Query(..., ge=-90, le=90),
    lng: float = Query(..., ge=-180, le=180),
    strategy: str = Query("safest"),
    set: Optional[str] = Query(None, description="shelter set, e.g. 'dmc', 'dmc+literature', 'osm'"),
):
    """Kept for compatibility. Prefer POST: this form puts the caller's
    coordinates in the URL, where they are logged."""
    return _trace_route(district, lat, lng, strategy, set)
