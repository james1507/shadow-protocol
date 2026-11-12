#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
GODOT=${GODOT:-godot}
mkdir -p docs/logs
"$GODOT" --version
"$GODOT" --headless --path . --editor --import > docs/logs/import.log 2>&1
"$GODOT" --headless --path . --script res://tests/run_tests.gd > docs/logs/tests.log 2>&1
"$GODOT" --headless --path . --script res://tests/playthrough.gd > docs/logs/playthrough.log 2>&1
"$GODOT" --headless --path . --quit-after 120 > docs/logs/smoke.log 2>&1
if rg -n 'SCRIPT ERROR:|^ERROR:' docs/logs/import.log docs/logs/tests.log docs/logs/playthrough.log docs/logs/smoke.log; then
  exit 1
fi
python3 tools/asset_inventory.py
python3 tools/prepare_assets.py
python3 tests/test_asset_tools.py
cat docs/logs/tests.log docs/logs/playthrough.log
