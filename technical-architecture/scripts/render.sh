#!/usr/bin/env sh
# Render one figure source to a 2x PNG with headless Chrome.
# Usage: sh render.sh <source.html> <width> <height> [out.png]
#   CHROME=/path/to/chrome overrides the binary (macOS default below; Linux: google-chrome).
set -eu
SRC="$1"; W="$2"; H="$3"; OUT="${4:-${SRC%.html}.png}"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
command -v "$CHROME" >/dev/null 2>&1 || CHROME=google-chrome
"$CHROME" --headless --disable-gpu --hide-scrollbars --virtual-time-budget=12000 \
  --screenshot="$OUT" --window-size="$W,$H" --force-device-scale-factor=2 \
  "file://$(cd "$(dirname "$SRC")" && pwd)/$(basename "$SRC")" 2>/dev/null
echo "rendered $OUT (${W}x${H} @2x)"
