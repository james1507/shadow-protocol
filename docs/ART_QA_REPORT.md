# V2 art QA — 2026-11-12

**VISUAL_MODE=ORIGINAL_FALLBACK.** No external ZIP supplied. Six original actors, 216 semantic clips, 12 SpriteFrames/profile resources. Engine: 4.7.2.stable.official.ed1daf0bf. No screenshots from vendor pages.

## Executed commands

```sh
GODOT=/Users/cmc-macmini/.local/share/shadow-protocol/Godot.app/Contents/MacOS/Godot
"$GODOT" --headless --path . --script res://tools/build_spriteframes.gd -- --images
"$GODOT" --headless --path . --editor --import
"$GODOT" --headless --path . --script res://tools/build_spriteframes.gd
GODOT="$GODOT" tools/validate_project.sh
"$GODOT" --path . --script res://tools/capture_v2.gd
"$GODOT" --path . --script res://tools/benchmark.gd
```

Actual local results: 35/35 V1 gameplay checks; 14/14 Godot art checks; 9/9 original Python asset checks; 5/5 new Python character-intake checks; physical-input campaign 3/3 missions with active AI. Saves isolated. Original bug encountered in art test harness (`PackedByteArray.hash` and missing await on async shutdown) was corrected; final logs contain no SCRIPT ERROR. Clean source-copy import/art/startup passed without .godot or incoming_assets. Byte hashes of 12 resources match across two consecutive rebuilds.

## ART-01..ART-22

| ID | Status | Actual evidence / limit |
|---|---|---|
| ART-01 | PASS | All committed profiles load; clean source-copy omits intake entirely |
| ART-02 | PASS | Exact PNG dimensions, filename, metadata and SHA-256 inspected using synthetic ZIP fixture; real intake empty |
| ART-03 | PASS | Traversal, absolute/drive/backslash names, ZIP symlink, existing symlink escape rejected |
| ART-04 | PASS | Missing/unverified license selects fallback; fixture with CC0 plus contradiction remains REVIEW_REQUIRED |
| ART-05 | BLOCKED | Actual premium absent. Synthetic selection/hash rejection passes, not a claim of vendor integration |
| ART-06 | BLOCKED | Actual free pack absent. Synthetic free selection passes, not a claim of vendor integration |
| ART-07 | PASS | Four distinct nonblank regions for every actor; agent viewed native front/back/sides in lab |
| ART-08 | PASS | Walk progress does not reset on repeated motion updates; stop retains facing |
| ART-09 | PASS | Exact diagonal retains facing; normalized physics covered by T01 |
| ART-10 | PASS | 360-degree quantization sweep and deadzone; viewport pointer motion ignores camera movement |
| ART-11 | PASS | Four held-pose attack clips with engine FX; actual runtime screenshot reviewed |
| ART-12 | PASS | 1.5x sprint playback and integer crouch offset; V1 stamina/speed tests retained |
| ART-13 | PASS | Latched nonlooping original fallen KO, lower-priority attack rejected; actual stunned guards cannot move/attack. Persistent guard KO is lab preview; campaign guards use timed V1 stun |
| ART-14 | PASS | Stun/alert overlays and reset, actual drone stun capture; EMP behavior retained by T23 |
| ART-15 | PASS | Shared (16,27) pivot across clips; collider transforms unchanged; agent reviewed anchors in gallery |
| ART-16 | PASS | Y-sorted actors/servers; doors and real wall motion covered by T14/T29; full tall-wall occlusion not added |
| ART-17 | PASS | viewport/keep/integer + nearest; genuine 640x360 capture and 1280x720 native lab viewed |
| ART-18 | PASS | Real graphical 10/20/40-agent samples in docs/v2-benchmark.json; M2 Pro only, no M1 guarantee |
| ART-19 | PASS | 20 real level reloads: stable signal counts, single player, exactly one visual per actor |
| ART-20 | BLOCKED | Clean source-copy import/art/startup PASSED. V2 has not been committed/pushed, so a clean clone of remote V2 cannot yet be tested |
| ART-21 | PASS | 12 resources byte-identical after two actual builder runs |
| ART-22 | PASS | Original labels/credits, original source code and genuine runtime captures; human aesthetic review pending |

Gate summary: **19 PASS, 0 FAIL, 3 BLOCKED**. Blocked gates concern optional real vendor packs and unpublished remote V2; original mode remains runnable. Agent visual inspection does not substitute for owner's subjective art approval.

## Manual visual review

Agent inspected native lab at 1280x720: front/back/left/right silhouettes and four attack arcs. Runtime PNGs reviewed for pixel sharpness, differentiated roster, fallen KO, pivots, menu/HUD bounds and gameplay. Menu lab button was moved after initial screenshot exposed clipped Quit; final capture includes both. Genuine captures live in docs/screenshots/character_showcase and v2-*.png.

Owner review outstanding: longer crouch/sprint/aim feel, all six actors through every action, narrow doorway/foreground aesthetics, reduced-effects preference, blind-human campaign duration, target M1, Windows/Linux execution. Final exported V2 macOS app also received native keyboard movement/EMP/pause/menu smoke review, with original production save backed up and restored byte-for-byte. Native full three-mission human-input completion is V1 evidence; V2 full completion is automated physical input, not a new claimed human playthrough.

## Screenshot provenance

`tools/capture_v2.gd` launches actual Godot renderer with an isolated save. Lab selectors are set through scene API; gameplay uses normal input for Level 1 movement. No promotional images, teleported actors, falsified FPS or objective changes. Captures are actual 640x360 viewport pixels; native CUA review used a 1280x720 window.

## Performance interpretation

See docs/v2-benchmark.json for raw process-frame intervals after one-second warmup and three-second sample windows. VSync requested, F3 off, same guard AI enabled, macOS Compatibility renderer, Apple M2 Pro. Derived FPS describes engine process-frame cadence, not externally measured displayed refresh. Samples do not establish improvement over V1 or predict M1 performance.
