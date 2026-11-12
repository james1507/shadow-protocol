# CODEX START PROMPT — SHADOW PROTOCOL V2.0 (CHARACTER ART UPGRADE)

You are the lead **Godot 4.7.2 / GDScript engineer, 2D technical artist and QA lead** working on **Shadow Protocol: Blacksite Breach** in the **CURRENT WORKSPACE**.

**READ FIRST (fully):** `SHADOW_PROTOCOL_MASTER_SPEC_V2.md`, including new overriding Sections **3A** and **14A**; then `ASSET_SETUP_GUIDE_V2_VI.md`. Read `project.godot`/`IMPLEMENTATION_STATUS.md` if this is an existing V1 project. Do not reset or overwrite working V1 gameplay.

## Non-negotiable build outcome

Build or upgrade the **complete, playable 3-level Godot 2D stealth game** from the full V2 master spec. Upgrade player, guard, heavy guard and drone to a consistent top-down cyberpunk character roster with correctly verified idle/walk/attack/hurt/KO 4-direction animation or explicitly implemented fallback. Preserve 8-way movement, player combat/stun, guard AI FSM, perception, checkpoints, save/load, HUD, camera, EMP, objectives and F3 debug. Implement a working character showcase scene.

## Choose legal assets by actual ZIP files

1. Inspect `incoming_assets/` for exact ZIP names and source license documents; never invent files. Use `zipfile` safely and inventory real PNG sizes, SHA256, license and any `assets.json` or spritesheet layout.
2. Preferred: **Riclmbr Pixel Cyberpunk Neon City** CC0 **only if the user-purchased ZIP is actually present** and its redistribution license is verified. Official page: https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets. **Do not buy or bypass checkout.** Map Netrunner/Mercenary player, Security Guard, SWAT, Security Bot, Scientist from actual files; adjust cast if metadata differs.
3. If premium missing: use **MurphysDad Sci-Fi Facility** CC0 ZIP if present and verified (Spy player, Hazmat guard, original compatible extra silhouettes). Official page: https://murphysdad.itch.io/sci-fi-facility.
4. If neither available: create clean original/procedural visuals; game must remain playable. Never declare premium installed or screenshots generated if they aren't.
5. NEVER include third-party art with forbidden AI-dataset use or unverified public redistribution. Especially avoid Sova and Danwolfe packs in this baseline. Do not mix side-view/isometric/high-definition characters with 32x32 pixel sprites.

## Implementation sequence

- Audit existing repo/game, back up before significant edits. Check actual Godot CLI version.
- Execute original V1 stages 0–11 if project is empty; otherwise review existing functions and implement missing V1 work without regressing working systems.
- Execute **V2-0..V2-7** (Section 14A) to upgrade art.
- Implement `tools/inspect_character_pack.py`, `tools/prepare_assets.py`, `tools/build_spriteframes.gd`, `config/asset_pack_registry.json`, `config/character_roster.json`, `CharacterVisual` scene/script, visual profiles, character showcase and art docs.
- Build SpriteFrames from **confirmed** ZIP metadata/regions. The premium source advertises a 128x352 atlas / 32x32 cells, but actual semantic row order and empty slots **are unknown** before unpacking. Do not hardcode guesses. Source advertises attack in 3 directions; fill the missing direction with a valid fallback (mirror only if truly safe; else engine FX).
- Validate logical 32px level grid vs imported 16px source tiles with a **single consistent** integer scaling policy. CharacterBody2D collision must NOT move when visual sprite pivot/animation changes.
- Run `--editor --import`, original test runner and **ART-01..ART-22**; include manual visual checklist. Failures must be fixed or clearly blocked with evidence.
- Produce genuine runtime screenshots only if you really launched the game. Update README, asset license audit, animation matrix, character art bible and `IMPLEMENTATION_STATUS.md`.

## Report honestly

At the end of each stage, state: changed files, selected visual mode (`PREMIUM_VERIFIED`, `FREE_VERIFIED` or `ORIGINAL_FALLBACK`), license evidence, commands ACTUALLY run, number of tests PASS/FAIL/BLOCKED, human visual checks outstanding, next task. A static code compile is not proof of a visually polished game.

**Start now. Do not ask me to reselect game engine/genre/architecture. Ask only for permission or manual purchase when truly required, and carry on with fallback in the same task.**
