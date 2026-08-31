#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
APP_DIR="${ROOT_DIR}/dist/Instagram Reels.app"
IDENTITY="${CODESIGN_IDENTITY:--}"

swift build -c release --package-path "$ROOT_DIR"
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
cp "$ROOT_DIR/.build/release/opencode-reels-browser" "$APP_DIR/Contents/MacOS/opencode-reels-browser"
cp "$ROOT_DIR/Resources/Info.plist" "$APP_DIR/Contents/Info.plist"
codesign --force --deep --sign "$IDENTITY" "$APP_DIR"
printf '%s\n' "Built $APP_DIR"
