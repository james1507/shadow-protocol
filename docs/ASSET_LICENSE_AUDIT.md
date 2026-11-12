# V2 asset license audit

Selected mode: **ORIGINAL_FALLBACK**. Intake inspected on 2026-11-12; no ZIPs present.

| Source | Archive / hash | Evidence | Adopted / redistribution |
|---|---|---|---|
| Original cast, server props, tiles, UI, audio | no vendor archive | LICENSE; tools/build_spriteframes.gd; scripts/world/foreground_prop.gd | included, MIT |
| Riclmbr Neon City | absent / none | publisher URL only; no archive license evidence | not adopted, not verified |
| MurphysDad Sci-Fi Facility | absent / none | publisher URL only; no archive license evidence | not adopted, not verified |
| Godot built-in font/runtime | engine distribution | in-game engine license notices | engine/dependency licenses |

Publisher pages (reference only):
- https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets
- https://murphysdad.itch.io/sci-fi-facility

No online license claim was substituted for an archive review. No paid purchase, restricted sprite pack, external font or scraped art included. Project MIT terms apply to original generated PNGs; they are not falsely labeled vendor CC0 work.

`inspect_character_pack.py` uses real ZIP SHA-256, PNG headers, exact filenames, metadata names and source document text. A CC0 substring does not approve a pack. Archive traversal, symlinks, existing symlink escapes and >500 MB expanded content are rejected through the shared safe extractor. Incoming code is never executed.

`prepare_assets.py --mapping config/asset_mapping.json` retains the V1 reviewed CC0 + exact hash gate. Vendor character regions require explicit reviewed roster mappings and verified license/redistribution evidence. Unknown or contradictory licenses retain original profiles. Selection fixtures in tests are synthetic and do not establish ownership/license of a real vendor pack.

Current used-file hashes: docs/CHARACTER_USED_FILES_SHA256.txt. Registry: config/asset_pack_registry.json. No raw vendor source is required to play the source project or exported game.
