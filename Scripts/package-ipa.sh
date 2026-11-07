#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DERIVED_DATA="${DERIVED_DATA:-$ROOT_DIR/build/DerivedData}"
APP_PATH="$DERIVED_DATA/Build/Products/Release-iphoneos/PersistentIsland.app"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT_DIR/artifacts}"
PAYLOAD_DIR="$OUTPUT_DIR/Payload"
IPA_PATH="$OUTPUT_DIR/PersistentIsland-unsigned.ipa"

test -d "$APP_PATH"
test -d "$APP_PATH/PlugIns/PersistentIslandWidget.appex"

rm -rf "$PAYLOAD_DIR"
mkdir -p "$PAYLOAD_DIR"
cp -R "$APP_PATH" "$PAYLOAD_DIR/"
rm -f "$IPA_PATH"
(cd "$OUTPUT_DIR" && /usr/bin/zip -qry "$(basename "$IPA_PATH")" Payload)
/usr/bin/unzip -l "$IPA_PATH"

