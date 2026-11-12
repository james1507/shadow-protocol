# Local V2 setup

Godot 4.7.2 Standard; no .NET or Python runtime needed to play. Import project.godot and F5. Main menu CHARACTER LAB exists in debug/source builds, or F6 on scenes/dev/character_showcase.tscn. Release builds omit developer scenes.

Current Mac engine:

```sh
GODOT=/Users/cmc-macmini/.local/share/shadow-protocol/Godot.app/Contents/MacOS/Godot
"$GODOT" --headless --path . --editor --import
"$GODOT" --path .
GODOT="$GODOT" tools/validate_project.sh
```

Run from repository folder. Source paths remain lowercase `projects/shadow-protocol` on this Mac; the example `~/Projects` in supplied guide is not a separate game checkout.

External ZIPs are optional. Place legally obtained original archives in incoming_assets. Run `python3 tools/inspect_character_pack.py --inventory`; review actual licenses/layout. Do not mark registry entries verified from a product page alone. Existing committed original sprites load without intake.

Rebuild original sprites/profiles using CHARACTER_ART_BIBLE.md commands. Validate source before `GODOT="$GODOT" tools/create_release.sh macOS` (or Windows/Linux). V2 outputs use builds/v2; V1 builds remain intact. macOS local signing is ad-hoc, not notarized.
