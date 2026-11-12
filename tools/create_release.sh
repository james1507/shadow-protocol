#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
GODOT=${GODOT:-godot}
PRESET=${1:-macOS}
case "$PRESET" in
  macOS|Windows|Linux) ;;
  *) echo 'Usage: create_release.sh [macOS|Windows|Linux]' >&2; exit 2 ;;
esac
mkdir -p builds/v2/macos builds/v2/windows builds/v2/linux
"$GODOT" --version
"$GODOT" --headless --path . --editor --import
"$GODOT" --headless --path . --export-release "$PRESET"
python3 - <<'PY'
from pathlib import Path
import hashlib
paths = [Path('builds/v2/macos/ShadowProtocol-v2.zip'),Path('builds/v2/windows/ShadowProtocol-v2.exe'),Path('builds/v2/linux/ShadowProtocol-v2.x86_64')]
rows = [hashlib.sha256(p.read_bytes()).hexdigest()+'  '+str(p) for p in paths if p.is_file()]
Path('builds/v2/SHA256SUMS').write_text('\n'.join(rows)+'\n')
print('\n'.join(rows))
PY
