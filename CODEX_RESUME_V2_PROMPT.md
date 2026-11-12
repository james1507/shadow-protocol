# CODEX RESUME / QUALITY GATE PROMPT — V2

Read `SHADOW_PROTOCOL_MASTER_SPEC_V2.md` entirely and inspect the current workspace. Read `IMPLEMENTATION_STATUS.md`, `config/asset_pack_registry.json`, `config/character_roster.json`, `docs/ART_QA_REPORT.md`, and actual `incoming_assets/` files if they exist.

**Do not reset the project or re-create working game systems.** Find the first incomplete or failing original V1 stage or V2-0..V2-7 stage. Continue from there. Priority: bootable game > correct premium/free/fallback character resource mapping > all scenes wired to CharacterVisual > sprite animation direction/feet anchors > consistent environment > 3-level regression > tests/documentation.

First, print concise factual stage status and `VISUAL_MODE`. Next, implement the next stage and run ACTUAL Godot headless imports/tests when binary available; show commands, logs and pass/fail. Continue through the remaining stages if possible. Never fabricate licenses, screenshots, screenshots of gameplay, purchases, FPS, or test successes.

If actor art is blank, inspect actual frame dimensions and `assets.json`/spritesheets, rebuild `.tres` with correct regions, and verify in `scenes/dev/character_showcase.tscn`. No hardcoded guessed row-to-animation mapping, no restricted dataset-use assets, and no silent AI-model training license violation.
