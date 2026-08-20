#!/usr/bin/env bash
# Copy the backend's precomputed GETRA data into the Flutter app as gzipped
# assets, so a fresh install has a full offline map and routing tables before it
# has ever reached the network.
#
# Run from the repo root after regenerating backend/data:
#   ./tool/sync_app_data.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/backend/data"
DST="$ROOT/app/assets/getra"

[ -d "$SRC" ] || { echo "error: $SRC not found" >&2; exit 1; }

rm -rf "$DST"
mkdir -p "$DST"

# The app fetches these by endpoint name, with no file extension, and caches them
# under the same keys. Asset names mirror those keys so the offline fallback and
# the network path stay interchangeable.
declare -a FILES=(
  "roads.geojson:roads"
  "inundation.geojson:inundation"
  "shelters.geojson:shelters"
  "nodes.json:nodes"
  "evac_basin.json:evac_basin"
)

gzip -9 -c "$SRC/districts.json" > "$DST/districts.json.gz"
echo "districts.json -> districts.json.gz"

for dir in "$SRC"/*/; do
  district="$(basename "$dir")"
  mkdir -p "$DST/$district"
  for entry in "${FILES[@]}"; do
    file="${entry%%:*}"
    key="${entry##*:}"
    [ -f "$dir/$file" ] || continue
    gzip -9 -c "$dir/$file" > "$DST/$district/$key.gz"
  done
  echo "$district -> $(du -sh "$DST/$district" | cut -f1)"
done

echo
echo "total bundled: $(du -sh "$DST" | cut -f1)"
