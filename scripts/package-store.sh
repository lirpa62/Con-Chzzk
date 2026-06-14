#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
VERSION="$(
  python3 - <<'PY' "${ROOT_DIR}/manifest.json"
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    print(json.load(f)["version"])
PY
)"
ZIP_NAME="Con-Chzzk-v${VERSION}.zip"
ZIP_PATH="${DIST_DIR}/${ZIP_NAME}"

INCLUDE_PATHS=(
  "manifest.json"
  "background.js"
  "content.js"
  "profile-power.js"
  "offscreen.html"
  "offscreen.js"
  "logpower-popup.css"
  "popup"
  "fonts"
  "sounds"
  "svg_texture"
  "icon_16.png"
  "icon_48.png"
  "icon_128.png"
  "icon_disabled.png"
  "hide_thumbnail.png"
  "thumbnail.gif"
)

cd "${ROOT_DIR}"

missing=()
for path in "${INCLUDE_PATHS[@]}"; do
  if [[ ! -e "${path}" ]]; then
    missing+=("${path}")
  fi
done

if (( ${#missing[@]} > 0 )); then
  printf 'Missing required package files:\n' >&2
  printf '  - %s\n' "${missing[@]}" >&2
  exit 1
fi

mkdir -p "${DIST_DIR}"
rm -f "${ZIP_PATH}"

zip -r "${ZIP_PATH}" "${INCLUDE_PATHS[@]}" \
  -x "*.DS_Store" \
  -x "__MACOSX/*" \
  -x "*/__MACOSX/*"

printf 'Created %s\n' "${ZIP_PATH}"
