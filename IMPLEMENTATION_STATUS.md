# V2 implementation status — 2026-11-12

**VISUAL_MODE=ORIGINAL_FALLBACK.** V2 upgrades existing V1 in place. Six original MIT pixel actors, 216 nonempty semantic animation clips, CharacterVisual on all four gameplay actor types, fixed feet, nearest/integer scaling, Y-sorted server props, scientist silhouette and Level 3 alternate guards. No premium/free asset ZIP supplied, purchased or adopted.

## Current verification

- Godot 4.7.2.stable.official.ed1daf0bf, existing local engine.
- Local validation: **35/35 gameplay + 14/14 Godot art + 9/9 original Python asset + 5/5 new character intake checks**, **3/3 physical-input campaign missions with active AI**, no final SCRIPT ERROR / ERROR.
- Actual art gates: **19 PASS / 0 FAIL / 3 BLOCKED**. Optional real premium/free integration and actual remote V2 clone cannot be tested yet. See docs/ART_QA_REPORT.md for each ART-01..22.
- 20 level reloads keep one player, one visual per actor and stable signal counts; colliders remain unchanged through stun.
- Two real builds produce byte-identical 12 SpriteFrames/profile resources.
- Clean source copy without .godot or incoming_assets: editor import, art suite and menu startup passed. This is not falsely called a remote Git clone.
- Actual graphical source lab viewed at 1280x720; real 640x360 runtime captures in docs/screenshots/character_showcase and v2-*.png. Fixed clipped Quit exposed by initial graphical review. Owner aesthetic approval remains pending.
- Graphical 10/20/40 guard timing samples: docs/v2-benchmark.json, M2 Pro / Compatibility renderer, VSync requested/F3 off. Mean process-frame intervals about 7.11/6.90/6.91ms; p95 12.28/10.05/10.94ms. Not a display-refresh measurement or a V1 optimization claim; M1 unmeasured.
- Actual V2 macOS/Windows/Linux exports succeeded under builds/v2, preserving V1 builds. macOS entry-menu CLI smoke and native exported keyboard movement/EMP/pause/menu review passed. Full V2 campaign completion is automated input; previous complete native-human-input campaign is V1 evidence. Windows/Linux not executed on target OSes.
- Native test production save backed up and restored byte-for-byte. Automated tests/captures use isolated saves; save schema remains version 1.
- Existing local Git baseline ab11d7b; origin already configured by owner. V2 publication was subsequently authorized by owner. Release target: https://github.com/james1507/shadow-protocol/releases/tag/v2.0.0. Prior untracked release-preview.jpg remains outside commit/release.

## V2 stages

All stages use ORIGINAL_FALLBACK, original code/PNG provenance under LICENSE. Exact build/test commands are in docs/SETUP.md, CHARACTER_ART_BIBLE.md and ART_QA_REPORT.md. Actual local logs are ignored under docs/logs.

| Stage | Result / files / evidence | Remaining review |
|---|---|---|
| V2-0 Audit | PASS: existing V1 preserved; sibling ZIP backup made before edits; ART_MIGRATION_PLAN.md; exact engine version | none |
| V2-1 Verify | PASS fallback: actual intake empty; inspect_character_pack.py, registry/license audit; safe intake fixtures pass | optional premium/free ZIP absent |
| V2-2 Data | PASS: roster, profile Resource, six PNGs, six SpriteFrames, six profiles, 216-row matrix; actual builder + resource bounds/nonblank tests | vendor mappings await real metadata |
| V2-3 Component | PASS: CharacterVisual scene/API, registry, player/enemy/attack/hack signal wiring; 35 V1 checks + campaign retained | full owner playtest |
| V2-4 Cohesion | PASS fallback: integer viewport, fixed colliders, shared palette/shadows, Y-sorted original server props | full wall-top occlusion not added; human aesthetics |
| V2-5 Showcase | PASS: selectors, nine states, four facings at 2x and detail 4x, all six cast; native view + true captures | owner subjective review |
| V2-6 QA | PASS locally: 49 Godot + 14 Python checks, 3/3 campaign, clean source copy, reload/rebuild checks, actual graphical benchmark | target M1, Windows/Linux runtime, blind duration |
| V2-7 Portfolio | PASS local source/builds/docs/screenshots: README, art bible/matrix, audit, QA, video guide, release report and V2 source ZIP | publication validation recorded below; no video |

## V2 limits

Original mode is intentionally disclosed; no premium visual quality claim. Attack/hurt/interact/crouch/stunned use documented held poses and engine FX; KO uses an original fallen frame. Campaign enemies retain timed V1 stun, not a new permanent-death mechanic. No fabricated vendor rows or unsafe mirroring. No 15–25-minute blind-human duration result, M1 measurement, Windows/Linux runtime proof, notarization, hosted CI or new V2 recorded video. Mac app is ad-hoc signed.

---

# V1 historical report (before owner GitHub setup)

The following records V1 evidence and historical repository state, not current V2 Git state.

# Implementation status — 2026-11-12

**Playable native release candidate.** Three authored missions completed through actual macOS desktop keyboard input and through the automated physical-input campaign. Godot 4.7.2 Standard, original art/audio, no external runtime dependencies. Source remains uncommitted in a new local Git repository; no remote, upload or hosted CI run.

## Actual verification summary

- Engine: `4.7.2.stable.official.ed1daf0bf`, downloaded from official Godot GitHub release linked by official archive.
- Local `tools/validate_project.sh`: exit 0, editor import + 35/35 Godot tests + 3/3 physical-input campaign missions + startup smoke + 9 Python asset checks. No SCRIPT ERROR / ERROR in final gate logs.
- Clean source copy without .godot cache: editor import and menu startup exit 0.
- Native source review: menu, movement, collision, F3, pause and actual screenshots.
- Actual exported macOS desktop play: L1 Gold 23.3s; L2 Bronze 81.2s after death/checkpoint retry; L3 Silver 46.7s; displayed total 151.3s. Normal simulation speed, known route, pauses between review actions. This is not a blind human duration study.
- Final exported New/Continue observed on native desktop after packaging. Final save persistence/Continue: T35 exercises final scene transition, versioned JSON write, all three results and Continue returning to results without duplicate actors.
- Graphical benchmark: M2 Pro / 16 GB, 10/20/40 guards, ~117–120 FPS with VSync and debug off. M1 remains unmeasured.
- Actual desktop exports: macOS ZIP, Windows x86_64 EXE, Linux x86_64 binary. Windows/Linux BUILT, NOT RUN-TESTED. macOS ad-hoc signed; no public notarization.

Commands use engine path `/Users/cmc-macmini/.local/share/shadow-protocol/Godot.app/Contents/MacOS/Godot`. `docs/logs/` holds actual local logs and is ignored by Git; no successful hosted CI is claimed.

## Stage 0 — Prerequisite audit
Status: PASS
Implemented files: project.godot, .gitignore, .gitattributes, copied master spec and Vietnamese asset guide, isolated shadow-protocol directory.
Validation: actual `--version`; official GitHub release API and archive inspected; git init; intake inventory.
Results: exact required stable engine available. Existing unrelated projects preserved. No external asset ZIPs supplied.
Manual checks: native desktop available.
Known issues: none blocking boot.
Next stage: complete.

## Stage 1 — Bootable application
Status: PASS
Implemented files: scenes/menus/main_menu.tscn, scenes/player/player.tscn, scenes/levels/level_01_access.tscn, scripts/player/player_controller.gd, scripts/world/grid_world.gd, scripts/ui/style.gd.
Validation: `--headless --path . --editor --import`; menu and first level `--quit-after 120`; native New Operation and movement.
Results: clean import/startup; real TileMapLayer physical walls, camera, keyboard-focusable menus. Fixed clipped Quit button, covered menu schematic and oversized bars after actual graphical review.
Known issues: none blocking play.
Next stage: complete.

## Stage 2 — Asset validation and fallback
Status: PASS
Implemented files: tools/asset_inventory.py, tools/prepare_assets.py, config/asset_mapping.json, scripts/world/asset_library.gd, docs/ASSET_SOURCES.md, docs/ASSET_INVENTORY.csv.
Validation: both Python tools exit 0; tests/test_asset_tools.py 9 checks pass; asset-free import/startup/campaign.
Results: zero third-party art/audio included. Original generated geometry/tiles and PCM tones, safe missing-asset behavior. Optional reviewed/hash-verified mappings supported. Traversal and existing symlink escapes rejected.
Manual checks: actual native visual fallback inspected and captured.
Known issues: Kenney packs not supplied/adopted; no downloaded atlas animation claims.
Next stage: complete.

## Stage 3 — Player, interactions and HUD
Status: PASS
Implemented files: health/stamina components, player controller, WorldItem reusable scenes, AttackService, HUD, ActorStats Resource.
Validation: T01–T06, T13–T15, T29–T34; native keycard/door/hack/pickup/checkpoint gameplay.
Results: normalized movement, timed stamina, damage/immunity, idempotent inventory, real LOS/range, canceled hacks, native bars/prompts/bearing/minimap.
Known issues: none blocking campaign. Native modifier-key ergonomics still worth checking on target keyboard; automated campaign actually crouches via normal Input actions.
Next stage: complete.

## Stage 4 — Enemy sensing and FSM
Status: PASS
Implemented files: enemy_controller.gd, vision_sensor.gd, EnemyConfig Resources, reusable guard scene, AStarGrid2D world routing.
Validation: T07–T12, T26–T27; real wall rays, state progression, noise/alert dedupe; native F3 and pursuit review.
Results: all eight states, gradual detection, hearing, LOS, chase/search/return, throttled paths and blocked-route recovery.
Known issues: production uses explicit AStarGrid2D door fallback. Arena heavy actively demonstrates real NavigationAgent2D in clear region; no dynamic navmesh rebaking claim.
Next stage: complete.

## Stage 5 — Combat and security types
Status: PASS
Implemented files: stun/EMP service, PulseEffect, EnemyProjectile, heavy/drone/camera scenes and tuning, synthesized audio.
Validation: T06/T11/T23/T24/T28; full native campaign with actual detection, damage, EMP and Game Over.
Results: one-target-per-swing, attack telegraphs, no wall penetration, EMP resistance/durations, camera resume, projectile lifetime/impact cleanup.
Known issues: Music bus/slider exists; no ambient music loop supplied. Audio uses original short tones.
Next stage: complete.

## Stage 6 — Three missions and progression
Status: PASS
Implemented files: all three level scenes, data/missions/level_01.json through level_03.json, mission_manager.gd, checkpoints/extraction/results.
Validation: T16/T17/T20/T25; tests/playthrough.gd actual New Game→three results; native macOS keyboard completion of all three missions.
Results: authored branching maps, correct prerequisite graphs, timed finale and no mandatory-route lockdown soft-lock.
Known issues: known-route play is shorter than 15–25-minute product target. Blind human duration/balance not validated; no duration claim made.
Next stage: complete.

## Stage 7 — Saves, settings and menus
Status: PASS
Implemented files: SaveManager, SettingsManager, AudioManager, main/settings/credits/results scenes, HUD pause/game-over controls, license notices.
Validation: T18–T22/T30–T35; native death, R retry, chapter progression and final results.
Results: validated atomic JSON, corrupt/future-version preservation, map/type/ID checks, objective/pickup/door restore, completed campaign persisted; separate ConfigFile settings. Pause halts actual hacks/timers.
Known issues: fullscreen/audio preferences need user ergonomic review on other OSes. Public signing/notarization not provided.
Next stage: complete.

## Stage 8 — Debug tools and reproducible scenarios
Status: PASS
Implemented files: live F3 HUD/world/enemy draw, EventBus 50-event ring with JSON dump and PageUp/PageDown browsing, isolated test_arena, F4 stress, real NavigationAgentDemoRegion.
Validation: T26/T27, native F3 inspection, graphical capture, actual 10/20/40 benchmark.
Results: real clipped rays/cones, routes, waypoints, noise radii, door footprints, state/position/count telemetry. Release gates debug and excludes arena.
Known issues: F3-heavy rendering not benchmarked.
Next stage: complete.

## Stage 9 — Tests, stabilization and CI
Status: PASS locally; hosted CI NOT RUN
Implemented files: 35-case zero-dependency SceneTree suite, native input campaign, Python trust-boundary checks, validate_project.sh, .github/workflows/godot-ci.yml.
Validation: final full local validation exit 0. Official Linux 4.7.2 release ZIP URL + SHA-256 pinned in workflow. No CI badge.
Results: initial T14 (27/28) exposed real card/objective namespace authorization bug; fixed and regressed. Initial eager --script autoload dependency issue fixed through runtime harness loading. Additional malformed-save/physical-motion/hack/menu/finished-save cases all pass.
Known issues: hosted CI and Windows/Linux runtime execution not performed.
Next stage: complete locally.

## Stage 10 — Portfolio and review
Status: PASS for documented native artifact; balance review remains
Implemented files: README, architecture/gameplay/maps/test plan, 5 engineering workflows, real debugging records, benchmark.json/PERFORMANCE.md, VIDEO_CAPTURE_GUIDE.md, three actual viewport screenshots.
Validation: tools/capture.gd actual PNGs; visual inspection; native whole-campaign completion; clean-copy import.
Results: consistent original palette, native menu/HUD, real procedural animation and license notices. Fixed active audio stream exit leak exposed by verbose graphical capture; repeated capture exits without warning.
Known issues: no gameplay video produced; no blind human length or subjective audio/art study.
Next stage: packaging complete below.

## Stage 11 — Packaging and handoff
Status: PASS for source and local desktop exports
Implemented files: export_presets.cfg, tools/create_release.sh, LICENSE, CHANGELOG.md, actual builds and checksum manifest.
Validation: official export template SHA-256 verified `f298490b8d44d934be425a5a65a51bf15f422428b229a06a6e11d9ffea248011`; matching templates installed. All three export commands exit 0. macOS desktop game completed all three missions. Initial universal export needed ETC2/ASTC flag; fixed, reimported, actual export passed.
Results: builds/macos/ShadowProtocol.zip; builds/windows/ShadowProtocol.exe; builds/linux/ShadowProtocol.x86_64. Checksums in builds/SHA256SUMS and docs/RELEASES.md. Local Git initialized, no commit/remote created.
Known issues: Windows/Linux not executed on matching OS; macOS not notarized. Final macOS release entry-menu command-line startup passed (exit 0, zero errors); native final New/Continue also verified. Official release engine disables scene/script path overrides, so additional release CLI scene harnesses are unavailable by design; native campaign and source campaign remain the completion evidence. Source ZIP recorded in release report.
Next action: user can play, review balance and inspect editable project.

## Acceptance matrix

| Gate | Status / actual evidence |
|---|---|
| A01 | PASS: native menu → level 1; contextual controls |
| A02 | PASS: normalized movement/crouch/sprint tests, bot crouch, native motion/walls; target-keyboard ergonomics review advisable |
| A03 | PASS: physical campaign + live path/arena; AStar door fallback disclosed |
| A04 | PASS: actual ray/FOV tests and clipped native debug draw |
| A05 | PASS: hearing/FSM/alert dedupe tests + native pursuit |
| A06 | PASS: hit dedupe/stun/EMP tests and native EMP use |
| A07 | PASS: sweeping camera implementation, disable/resume test and native security encounter |
| A08 | PASS: tests + native card/door/hack/checkpoint/chip |
| A09 | PASS: all 3 native desktop levels completed; physical bot separately 3/3 |
| A10 | PASS: explicit prerequisite/extraction rejection tests |
| A11 | PASS: disk/scene roundtrip, corrupt/future input, real death retry, completed Continue T35 |
| A12 | PASS: all menu scene smoke + actual pause/death/results; settings persistence implemented |
| A13 | PASS: native live F3 inspection + actual debug screenshot |
| A14 | PASS: zero optional asset campaign, synthesized/safe absent audio |
| A15 | PASS: no external art/audio, original provenance and secure intake tools |
| A16 | PASS: 35/35 Godot + 9 Python asset checks |
| A17 | PASS: import/startup + clean source-copy import/startup |
| A18 | PASS: README, actual menu/gameplay/debug PNGs, reproducible commands/docs |
| A19 | PASS builds; macOS played; Windows/Linux built only |
| A20 | MEASURED on M2 Pro; target M1 NOT MEASURED |

## Remaining scope and truthful limitations

No public repository/hosted CI/video. No Kenney packs used. Original geometric art and short synthetic sounds are final fallback for this build. Production door pathfinding uses documented grid fallback. Blind human 15–25-minute length, target M1 performance, long-session memory/frame pacing, Windows/Linux play and public macOS notarization remain unverified. These do not prevent running the complete local campaign.
