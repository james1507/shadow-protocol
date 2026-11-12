#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
GODOT=${GODOT:-godot}
PRESET=${1:-macOS}
case "$PRESET" in
  macOS|Windows|Linux) ;;
  *) echo 'Usage: create_release.sh [macOS|Windows|Linux]' >&2; exit 2 ;;
esac
mkdir -p builds/macos builds/windows builds/linux
"$GODOT" --version
"$GODOT" --headless --path . --editor --import
"$GODOT" --headless --path . --export-release "$PRESET"
python3 - <<'PY'
from pathlib import Path
import hashlib
paths = [Path('builds/macos/ShadowProtocol.zip'),Path('builds/windows/ShadowProtocol.exe'),Path('builds/linux/ShadowProtocol.x86_64')]
rows = [hashlib.sha256(p.read_bytes()).hexdigest()+'  '+str(p) for p in paths if p.is_file()]
Path('builds/SHA256SUMS').write_text('\n'.join(rows)+'\n')
print('\n'.join(rows))
PY
