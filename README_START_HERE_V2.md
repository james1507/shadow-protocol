# SHADOW PROTOCOL — V2 CODEX INPUT PACKAGE

This package contains specifications/prompt files **only**. It does not contain the Godot game, an itch.io paid ZIP, or claimed gameplay screenshots.

## Included

1. `SHADOW_PROTOCOL_MASTER_SPEC_V2.md` — full standalone build spec (V1 gameplay + V2 character/animation improvements).
2. `ASSET_SETUP_GUIDE_V2_VI.md` — Vietnamese manual steps for Godot, paid/free asset download and folder placement.
3. `CODEX_START_V2_PROMPT.md` — copy into Codex after placing the master spec/asset ZIPs in workspace.
4. `CODEX_RESUME_V2_PROMPT.md` — for interrupted Codex builds.
5. `README_START_HERE_V2.md` — this file.

## Recommended path

**Best visual quality:** user purchases/downloads Riclmbr pack and adds ZIP to `incoming_assets/` (license shown as CC0). **Free:** download MurphysDad Sci-Fi Facility ZIP to `incoming_assets/`. No external assets: generated fallback remains playable, but doesn't match premium visuals.

Extract package files into an existing project root or an empty folder `~/Projects/shadow-protocol/`. Put ZIPs in `incoming_assets/`. Open Codex in that workspace, paste `CODEX_START_V2_PROMPT.md`. After implementation, launch Godot and review `character_showcase.tscn`, all 3 levels and tests. Record only genuine screenshots/gameplay.

V2 adds cast/pivots/direction fallback, import pipeline, animation state handling, asset license auditing, character showcase and 22 art-specific checks. **No asset ZIP is included in this package.**
