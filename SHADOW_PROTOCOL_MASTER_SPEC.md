# SHADOW PROTOCOL — COMPLETE GODOT GAME BUILD SPECIFICATION

> **Audience:** An autonomous coding agent (Codex) responsible for implementing, validating, documenting and packaging a playable Godot game from an empty directory.
>
> **Edition:** 1.0 — 12 November 2026
> **Target:** Godot **4.7.2 stable**, **GDScript**, 2D top-down desktop game, single-player, keyboard + mouse, suitable for a public GitHub portfolio and a technical Godot interview.
>
> **IMPORTANT:** This is a BUILD SPECIFICATION, not a description of an existing game. The agent must implement the game and prove it runs. Never report a milestone completed unless the corresponding scenes/scripts exist and the validation steps pass.

---

## 0. NON-NEGOTIABLE AGENT EXECUTION CONTRACT

You are building a **playable, finished small game**, not a scaffold, slide deck, screenshots of a concept, or pseudocode. Work sequentially from Stage 0 to Stage 11 below, running tests after each stage. Follow the instructions in this order:

1. Inspect the working directory, OS, existing files and available `godot` executable. Do not overwrite user files without a backup. If the folder is empty, initialize a Godot project.
2. Target Godot **4.7.2 stable**. Use the Godot standard (non-.NET) editor and GDScript. Do not silently migrate to beta or rely on Godot 3 APIs.
3. Look for assets in `incoming_assets/`. Inspect archive contents and license documents; DO NOT assume archive internal filenames, tile sizes, spritesheets or animation names. Follow **Section 3** and `ASSET_SETUP_GUIDE_VI.md`.
4. Try to acquire only assets through their official page or a verifiable, publisher-provided download endpoint. If downloads require a browser click, paywall, anti-bot, account or consent, **do not bypass**. Use a generated CC0-safe original/procedural art fallback, keep the game playable and write down which downloads the human should perform.
5. NEVER use copyrighted game sprites, music, recognizable characters, scraped images, or license-ambiguous media. CC0 assets may be committed; still record their original source and author in `docs/ASSET_SOURCES.md`.
6. Do NOT create fake tests, fake gameplay captures, fake benchmark measurements, fake downloadable builds or fake completion claims. Never write “tested” unless execution produced a real pass result.
7. No runtime or test dependencies requiring proprietary cloud APIs. No external network needed after initial asset acquisition. No Unity, Unreal, Flutter, Electron, web frontend or Python runtime for gameplay.
8. Code quality: typed GDScript when practical, focused responsibilities, descriptive names, reusable scenes, configurable `Resource` data and signals for decoupling. Avoid huge singleton scripts or circular autoload dependencies.
9. Make the game launch with **F6/F5 in editor and `godot --path .`** after import, including when all optional asset downloads are absent. An asset pack must NEVER be a build-time blocker.
10. If the engine binary is unavailable in the agent environment, generate the complete source/project, perform available static checks, and state precisely which runtime checks are BLOCKED; never claim runtime verification without it.
11. Use English for in-game UI, README, architecture docs and interview case studies. The assets guide for the user is Vietnamese. Keep spelling and nomenclature consistent.
12. Do not stop at an unrelated error. Fix and re-run gates, make small commits only if repository/user permissions allow, and leave a clear `IMPLEMENTATION_STATUS.md` listing actual state and limitations.

**Definition of done:** 3 authored levels with a coherent start-to-finish loop; functional player, enemies, mission objectives, interactions, combat, save/load, UI, audio/fallback, debug overlay, tests, docs and a distributable build when export templates are available. See Section 20.

---

## 1. PRODUCT BRIEF & PLAYER EXPERIENCE

**Name:** Shadow Protocol: Blacksite Breach

**Pitch:** A stealth operative infiltrates a restricted research facility to recover classified research. Evade patrol guards, security cameras and drones. Use keycards, short EMP bursts, non-lethal stun tools and terminals to reach a data vault and escape before the security system locks down.

**Genre:** 2D top-down tactical stealth/action game with deliberate combat and lightweight puzzle elements.

**Reference mood (not license to copy):** industrial sci-fi, readable geometric silhouettes, dark navy base, cyan interactive objects, orange suspicious indicators, red danger alarms, simple character animations.

**Core loop:** scout corridor → observe patrol/vision cones → move silently or distract enemies → collect access card → interact with terminal → unlock secured route → acquire objective → extract → level result.

**Primary differentiator for technical portfolio:** inspectable Enemy AI with deterministic state transitions and an F3 Developer Overlay that visualizes sensing, navigation and performance. The source should be easy to convert into reproduce/debug/evaluate tasks.

**Audience:** Recruiters / developers reviewing a 5–12-minute gameplay demonstration and the underlying Godot project.

**Release scope:** Windows, macOS and Linux desktop source-first. Export desktop builds when possible. HTML5/web is optional after desktop quality gates, not an alternative to the native build.

**Display:** internal reference 640×360, integer-scaled viewport/window 1280×720; aspect 16:9; canvas items / Nearest filter for pixel art; letterbox to avoid distortions; 60 physics FPS. UI may use higher resolution fonts if readable.

**Game length:** 15–25 minutes for all three levels on Normal, with a 5–8-minute short path for video demonstration. No open-world, networking, microtransactions or online accounts.

---

## 2. USER STORY, CONTROLS, RULES AND BALANCE

### 2.1 Controls / Input Map

| Action ID | Keyboard / Mouse | Behavior |
|---|---|---|
| `move_up` / `move_down` / `move_left` / `move_right` | W/S/A/D + arrows | Normalized 8-way movement |
| `sprint` | Left Shift (hold) | Increased speed, consumes stamina, produces hearing event |
| `crouch` | Left Ctrl (hold) | Reduced speed, reduced enemy detection/noise |
| `interact` | E | Interaction target nearest within range and with line of sight |
| `attack` | Left mouse | Non-lethal stun baton swing/short shock projectile (configurable; see 6.5) |
| `gadget` | Q | EMP pulse if one is available |
| `reload_checkpoint` | R on Game Over only | Respawn at checkpoint; do not hijack R in normal play |
| `pause` | Esc | Pause, resume, settings, restart, quit to menu |
| `developer_overlay` | F3 | Debug stats / AI visuals in debug builds; disabled in release by default |
| `dev_spawn` | F4 | Optional debug-only test helper; never enabled in standard play |
| `ui_accept` | Enter/Space | Menus and confirmations |

Implement in `project.godot` InputMap. Mouse cursor used for aiming; the player's facing direction updates reliably while stationary. Keyboard-only interaction and menu support are mandatory.

### 2.2 Movement and health (initial tuning)

- Player walking speed **95 px/s**, sprint **145 px/s**, crouch **58 px/s**. Separate configurable player balance resource.
- Player max health **100**, max stamina **100**, sprint drain **24/s**, regen **18/s** after **0.6 s** without sprinting. No sprint if stamina below 10; resumes after recovery; clamp never negative.
- Interaction distance **40 px**, attack cooldown **0.55 s** and usable range **43 px**. Attack causes **1.5 s stun** and does not instantly kill ordinary guards. Consider adding upgrades only after base game is stable.
- Enemy attacks have clear wind-up of at least **0.35 s**, range limited by physics check, cooldown **1.25 s**, damage **15** from guard and **10** from drone pulse. No damage through walls.
- Health pickup restores **30** up to max; EMP charge max carry **3**, starts with **1** on Normal difficulty.
- Difficulty: Normal only required, Easy optional. No upgrade economy, crafting or experience levels in v1.

All numbers are defaults exposed via `.tres` Resources; values may be tuned from playtesting, with changes documented.

### 2.3 Win/fail conditions

- Win a level only when **all mandatory objectives are complete** AND the player enters/unlocks extraction while alive.
- Lose when `health <= 0`; show Game Over and offer retry from last checkpoint or main menu.
- Pause works in gameplay but does not progress timers or animations with wrong processing modes.
- A collected keycard/terminal should not trigger twice or duplicate rewards.
- If the player enters extraction early, show exactly which prerequisite is missing; do not soft-lock or advance.

---

## 3. ASSETS: VERIFIED SOURCES, EXACT DOWNLOAD STEPS, LICENSES AND ADOPTION POLICY

### 3.1 Download matrix (official product pages)

**The source links are official product pages, not invented direct ZIP links.** User can click **Download**, then **Continue without donating...** if that modal appears, and save the resulting archive. Assets are not assumed to download automatically from terminal.

| Pack / exact official URL | Role | Priority | License shown on publisher's page |
|---|---|---|---|
| Kenney Top-down Shooter — https://kenney.nl/assets/top-down-shooter | Characters, top-down props, floor/furniture candidates, projectile art | **Required preference** | CC0 |
| Kenney Sci-Fi RTS — https://kenney.nl/assets/sci-fi-rts | Sci-fi structure/building/prop candidates; **do not assume compatible perspective** | Optional | CC0 |
| Kenney UI Pack — Sci-Fi — https://kenney.nl/assets/ui-pack-sci-fi | Menu panels, buttons, sci-fi widget skins | **Required preference** | CC0 |
| Kenney Sci-Fi Sounds — https://kenney.nl/assets/sci-fi-sounds | Terminal, security, drone, warning sound candidates | Recommended | CC0 |
| Kenney Interface Sounds — https://kenney.nl/assets/interface-sounds | UI clicks, hover, confirm, error | Recommended | CC0 |
| Kenney Impact Sounds — https://kenney.nl/assets/impact-sounds | Combat hits, collision impact | Recommended | CC0 |
| Kenney Game Icons — https://kenney.nl/assets/game-icons | HUD/input / item icon candidates | Optional | CC0 |
| Kenney Music Jingles — https://kenney.nl/assets/music-jingles | Optional menu/completion sting; **not a substitute for an appropriate ambient loop** | Optional | CC0 |
| Godot editor 4.7.2 stable — https://godotengine.org/download/archive/4.7.2-stable/ | Game engine, NOT a game asset | Required | Godot's own engine license |

**Asset verification as of 2026-11-12:** Official Kenney page labels for these packs state CC0. Recheck each pack's actual downloaded license text. If a future download changes licensing, its license file controls; never assume a third-party mirror is equally licensed. Full URLs and validation policy belong in `docs/ASSET_SOURCES.md`.

**Warning:** Kenney *Top-down Shooter* contains zombie-themed/modern assets and Kenney *Sci-Fi RTS* may be RTS-perspective. They are **not guaranteed to be a ready-made cohesive cyberpunk stealth pack**. Adapt palettes/layouts carefully, and use procedurally drawn original guard/drone/security shapes where necessary. Never blindly claim “four-direction walking/attack sprites” exist before inspecting PNG dimensions and animations. An unanimated sprite is allowed initially; draw animated facing/motion via Godot if needed.

### 3.2 Human downloads — macOS

1. Open each official pack URL in a browser.
2. Check **License: Creative Commons CC0** on that pack's page.
3. Press **Download**. When a support/donation screen appears, click **Continue without donating...** if you want the free pack. Do not click a paid bundle by mistake.
4. Save archive in `~/Downloads/` (browser may rename archives; avoid guessing filenames).
5. Create `<repo>/incoming_assets/` and put the downloaded archives there. The original archives may remain **git-ignored** as intake artifacts.
6. In Terminal run `cd <repo>`; `mkdir -p incoming_assets`; `find incoming_assets -maxdepth 2 -type f` to confirm files.
7. For each ZIP, run `unzip -l "incoming_assets/<actual-file>.zip" | head -50` and extract it to `incoming_assets/extracted/<pack-id>/` (or have the agent perform these steps on actual downloaded archives).
8. Do NOT arbitrarily rename or move assets inside the source ZIP first. Record original source name, source license, actual dimensions and original filenames in the manifest.
9. Agent should copy only selected necessary CC0 assets into `assets/`, normalize their naming, and keep a mapping back to original paths. Avoid committing duplicate pack folders or unnecessary large preview images.
10. Open project in Godot and allow import to complete; assign Texture/CanvasItem filtering and atlas regions as verified by the pack's actual image geometry. If no download is available, continue with fallback assets.

### 3.3 Required project-side asset ingestion scripts

Implement `tools/asset_inventory.py` using **Python 3 standard library** (`zipfile`, `pathlib`, `hashlib`, `csv`, `struct`, `json`; optional Pillow only if already available). It must:
- Enumerate archives and extracted assets; reject unsafe paths when extracting (ZIP path traversal).
- Read PNG width/height from header; list extensions, sizes, SHA-256 and apparent folders.
- Detect and copy original license/readme files into `docs/licenses/` when found.
- Emit `docs/ASSET_INVENTORY.csv` and `docs/ASSET_SOURCES.md` with attribution/CC0 source links and sha hashes.
- Report any unknown/missing license or unsupported files; **do not label unverified packs CC0**.
- Output clearly: `source_pack,source_url,license_status,original_path,destination_path,sha256,width,height,used_in_scene`.
- Identify pixel atlas/spritesheets *only after* examining layout; no hard-coded slicing based on guessed tile sizes.

Implement `tools/prepare_assets.py` that reads a **human-reviewed** `config/asset_mapping.json` and copies exact vetted files to project folders. The mapping has `source_pack`, `source_relative_path`, `destination`, `license_id`, `usage`, `frame_width`, `frame_height` (frame fields optional). Missing source file should produce a **reported warning + placeholder fallback** rather than crashing the entire project. Do not download from arbitrary URL or mutate original source ZIPs.

### 3.4 Placeholder / original fallback (must ship)

The game must play with **zero external downloads**, by using original engine-native visuals:
- Draw floor/wall/door grids with simple shapes, gradient-free flat colors or original generated pixel textures.
- Draw player and guards with clearly differentiated colored polygon/Polygon2D bodies, arrow facing indicator and simple `AnimationPlayer` bob/rotate/flash effects.
- Draw security cameras, terminal, keycard, health pack, EMP and extraction marker using original polygonal silhouettes; ensure each is identifiable at 640×360.
- Use Godot UI controls with original simple StyleBoxFlat and Font resources if Kenney UI not installed.
- Use silent fallback AudioStream logic if no sound files. Never access missing audio `res://` paths.

**Important:** Temporary fallback is not an excuse to ship an ugly final result if the requested packs are available. The final game should have consistent visual treatment and a documented asset mapping; fallback is for reliability.

### 3.5 Final asset folder contract

```
assets/
  characters/player/         # actual used sprites, if licensed/available
  characters/enemies/
  environment/floors/
  environment/walls/
  environment/doors/
  environment/props/
  items/
  effects/
  ui/
  audio/sfx/
  audio/music/
  fonts/
  generated/                # original fallback art
incoming_assets/            # git-ignored incoming ZIPs
config/asset_mapping.json   # exact mapping for selected source files
docs/ASSET_INVENTORY.csv
docs/ASSET_SOURCES.md
docs/licenses/
```

Any original assets created by the project must be clearly distinguished from third-party ones. Do not depend on a font without permission to redistribute it; built-in Godot fonts are acceptable.

---

## 4. ARCHITECTURE AND REPOSITORY LAYOUT

Required top-level layout (expand sensibly; do not create empty placeholder files):

```
shadow-protocol/
  project.godot
  icon.svg                        # own simple vector mark
  LICENSE                         # game/source code license (MIT or chosen permissive license)
  README.md
  IMPLEMENTATION_STATUS.md
  CHANGELOG.md
  .gitignore
  .gitattributes
  .github/workflows/godot-ci.yml
  assets/ ...
  incoming_assets/ ...
  config/
    asset_mapping.json
    balance/player.tres
    balance/guard.tres
    balance/heavy_guard.tres
    balance/drone.tres
  scenes/
    bootstrap/main.tscn
    menus/main_menu.tscn
    menus/pause_menu.tscn
    menus/settings_menu.tscn
    menus/game_over.tscn
    menus/results.tscn
    player/player.tscn
    enemies/guard.tscn
    enemies/heavy_guard.tscn
    enemies/drone.tscn
    interactables/door.tscn
    interactables/terminal.tscn
    interactables/keycard.tscn
    interactables/health_pickup.tscn
    interactables/extraction_zone.tscn
    interactables/checkpoint.tscn
    gadgets/emp_pulse.tscn
    combat/stun_hitbox.tscn
    ui/game_hud.tscn
    ui/developer_overlay.tscn
    levels/level_01_access.tscn
    levels/level_02_vault.tscn
    levels/level_03_escape.tscn
    levels/test_arena.tscn
  scripts/
    autoload/game_manager.gd
    autoload/event_bus.gd
    autoload/save_manager.gd
    autoload/audio_manager.gd
    autoload/settings_manager.gd
    components/health_component.gd
    components/stamina_component.gd
    components/interaction_component.gd
    components/hitbox_component.gd
    components/hurtbox_component.gd
    player/player_controller.gd
    enemies/enemy_controller.gd
    enemies/vision_sensor.gd
    enemies/hearing_sensor.gd
    enemies/state_machine.gd
    enemies/states/*.gd
    combat/attack_service.gd
    missions/mission_manager.gd
    missions/objective.gd
    world/level_controller.gd
    world/navigation_sync.gd
    ui/hud_controller.gd
    ui/developer_overlay.gd
  resources/
    actor_stats.gd
    enemy_config.gd
    mission_definition.gd
    settings_data.gd
  data/
    missions/level_01.json
    missions/level_02.json
    missions/level_03.json
  tests/
    run_tests.gd
    test_health.gd
    test_stamina.gd
    test_enemy_fsm.gd
    test_vision.gd
    test_mission.gd
    test_inventory.gd
    test_save_manager.gd
    test_level_integrity.gd
    test_integration.gd
  tools/
    asset_inventory.py
    prepare_assets.py
    validate_project.sh
    create_release.sh
  docs/
    ASSET_SOURCES.md
    ASSET_INVENTORY.csv
    ARCHITECTURE.md
    GAMEPLAY_SYSTEMS.md
    LEVEL_DESIGN.md
    TEST_PLAN.md
    DEBUGGING_CASE_STUDIES.md
    PERFORMANCE.md
    REPRODUCE_WORKFLOWS.md
    VIDEO_CAPTURE_GUIDE.md
    screenshots/                    # real captures only
```

### 4.1 Design principles

- **Godot scenes own spatial/visual state**; components encapsulate health, collisions and stamina; resources hold balance settings.
- **Autoloads only for cross-scene services** (game flow, saves, settings, audio, signals). UI must not directly mutate enemy state through global singleton properties.
- Use **signals**: `health_changed`, `died`, `objective_completed`, `alarm_changed`, `inventory_changed`, `door_unlocked`, `level_completed`, `noise_emitted`.
- No permanent reference cycles between player/UI/level; connect signals on spawn and disconnect on disposal when relevant.
- All actions affecting health, inventory or score must be **single-authority** (one method updates authoritative value and emits signal once).
- Avoid opaque dynamically generated scene text if Godot scripts can build them consistently. `.tscn` should be valid and editor-inspectable; handcrafted `.tscn` needs parser validation.
- Store critical gameplay parameters in Resources, not duplicated constants in multiple scripts.

### 4.2 Collision & navigation layers (document exact bit values)

- Layer 1 `WORLD_SOLID`: walls, solid props, closed blocking doors.
- Layer 2 `PLAYER`: player CharacterBody2D.
- Layer 3 `ENEMY`: guards, drones.
- Layer 4 `PLAYER_ATTACK`: player nonlethal attack / EMP hitboxes.
- Layer 5 `ENEMY_ATTACK`: hostile attack areas.
- Layer 6 `INTERACTABLE`: interaction areas and pickups (non-solid).
- Layer 7 `SENSOR`: sensor areas; keep trigger filtering focused.
- Layer 8 `PROJECTILE`: if used.

Set masks deliberately. Document matrix in `docs/ARCHITECTURE.md` and test: wall blocks player/guard/projectiles; attack doesn't damage owner; pickup trigger doesn't block movement; camera line of sight is blocked by solid obstacles.

---

## 5. SCENE TREES AND GODOT NODE CONTRACTS

### 5.1 Player scene

```
Player (CharacterBody2D) [player_controller.gd]
  VisualRoot (Node2D)
    Sprite2D or AnimatedSprite2D (fallback Polygon2D)
    FacingMarker (Node2D)
  CollisionShape2D
  InteractionArea (Area2D)
    CollisionShape2D
  AttackOrigin (Marker2D)
  HealthComponent (Node)
  StaminaComponent (Node)
  AnimationPlayer
  Camera2D
  AudioStreamPlayer2D
```

Player uses `move_and_slide()` from `_physics_process()`. Normalize diagonal movement; clamp position via collision not screen coordinate hacks. Camera follows smoothly but must not show outside level bounds; update bounds per level.

### 5.2 Guard / Heavy Guard scene

```
Guard (CharacterBody2D) [enemy_controller.gd]
  VisualRoot (Node2D)
    Sprite2D / Polygon2D
    StateIcon
  CollisionShape2D
  NavigationAgent2D
  VisionRay (RayCast2D) OR direct physics ray query
  DetectionArea (Area2D)        # broadphase only
    CollisionShape2D
  AttackArea (Area2D)
    CollisionShape2D
  HealthComponent (Node)        # includes incapacitation/stun if desired
  StateMachine (Node)
    Patrol (Node)
    Suspicious (Node)
    Investigate (Node)
    Search (Node)
    Chase (Node)
    Attack (Node)
    Stunned (Node)
    ReturnToPatrol (Node)
  AnimationPlayer
  AudioStreamPlayer2D
```

An enemy can occupy **exactly one logical state** at any time, maintain its own blackboard (last seen player position, alert level, current target), and never continue moving/attacking while stunned. Avoid spawning alert animations every physics frame.

### 5.3 World / level scene

```
LevelRoot (Node2D) [level_controller.gd]
  Ground (TileMapLayer)
  Decoration (TileMapLayer)
  Walls (TileMapLayer)           # configured collision
  NavigationRegion2D            # traversable surface; deterministic nav mesh
  Props (Node2D)
  Interactables (Node2D)
  Enemies (Node2D)
  PatrolWaypoints (Node2D)
  PlayerSpawn (Marker2D)
  Extraction (Area2D)
  LevelTriggers (Node2D)
  CameraBounds (Node2D)
```

Use TileMapLayer not deprecated Godot 3 TileMap APIs. If external sprites don't provide a correctly sized atlas, original grid-drawn floor and a smaller configured TileMapLayer are acceptable, but the final level must actually use TileMapLayer and its collision feature. All three levels must be authored and testable.

### 5.4 HUD and overlay

```
GameHUD (CanvasLayer)
  Root (Control)
    TopLeft (VBoxContainer)
      HealthBar (ProgressBar)
      StaminaBar (ProgressBar)
    TopRight (VBoxContainer)
      MissionTitle (Label)
      ObjectiveList (VBoxContainer)
      AlarmStatus (Label)
    BottomCenter (Label)         # interaction prompt
    BottomRight (HBoxContainer) # keycards / EMP charge / gadget
    Notifications (VBoxContainer)
    Crosshair (optional Control)
DeveloperOverlay (CanvasLayer)
  DebugPanel (PanelContainer)
    Stats (RichTextLabel or Labels)
```

Ensure HUD scales/anchors sensibly and does not obscure the player's position at 640×360.

---

## 6. CORE SYSTEMS — REQUIRED IMPLEMENTATION DETAILS

### 6.1 Player movement and animation

- Four or eight directional facing; animation state `idle`, `walk`, `sprint`, `crouch`, `attack`, `hurt`, `down`.
- If no spritesheets exist, implement readable procedural character silhouettes and action animations with AnimationPlayer/Tweens. Do not reference `res://assets/characters/player/walk.png` until file exists.
- Sprint makes a noise event at most once every configurable **0.6 s** rather than every frame; crouch significantly reduces it. Stamina logic must be frame-rate-independent.
- Collision should prevent tunneling through corners at normal movement speeds. Mouse aiming uses global mouse position, transformed properly with Camera2D.

### 6.2 Interaction system

- Reusable `IInteractable`-like convention in GDScript: `can_interact(actor) -> bool`, `get_interaction_label() -> String`, `interact(actor) -> void` (GDScript duck typing is acceptable).
- Find nearest eligible candidate within 40 px and line of sight, stable selection if two overlap; E triggers exactly once per key press.
- Prompt: `E — Pick up Blue Keycard`, `E — Hack Security Terminal`, `E — Open Secured Door`, `E — Extract`.
- Interaction can't occur when player is dead, paused or too far. Terminal should support canceled interaction if player moves away or is damaged.

### 6.3 Health / damage / collisions

- Health component exposes `apply_damage(amount, source_id)`, `heal(amount)`, `die()`. Clamp to `[0, max]`, ignore nonpositive damage, no double-death signals.
- Player receives **0.6 s** post-hit invulnerability against repeated overlapping hurtboxes (configurable); visible flash and clear hit feedback.
- A nonlethal stun attack has one target application per swing (`hit_id`/visited set), even when a hitbox overlaps across several physics frames.
- Impact VFX and SFX are emitted on actual hit, not on speculative animation frame.

### 6.4 Enemy perception and alert system

- Detection has **two checks**: broadphase distance/Area2D and actual **angle + raycast** line-of-sight. A wall must block detection.
- Guard visual detection radius default **150 px**, total FOV **90 degrees**; heavy **165 px / 100 deg**; drone **190 px / 110 deg**. Detection accumulation is gradual (e.g. 0.9 seconds fully visible on Normal), decreases slowly while hidden; avoid instant impossible-to-avoid spotting.
- Stance modifiers: crouch reduces effective detection range by roughly 30%; sprint makes detection accumulation faster if visible. Do not ignore walls.
- Hearing: player emits noise events with position, radius, type; guards in range move to last heard location, not directly to the player unless visually confirmed.
- On sighting, publish one cooldown-limited global/nearby alert. Neighbor guards investigate when within **220 px**, with max one propagation per `alert_id` to prevent alert storms.
- Search lasts **6 s**; guard scans plausible last-seen position before returning to patrol. Alert indicator HUD responds to state.
- Cameras rotate/sweep on a bounded arc, can raise alarms, can be disabled by EMP for **5 s** and must correctly resume afterward.

### 6.5 FSM — exact states and transitions

| State | Entry | Update | Exit criteria |
|---|---|---|---|
| PATROL | Set current waypoint | Walk waypoints, scan | Noise→INVESTIGATE; partial detection→SUSPICIOUS; full sight→CHASE |
| SUSPICIOUS | Stop/slow, show `?` | Investigate sightline and accumulate confidence | Full visual→CHASE; confidence cleared→PATROL; noise→INVESTIGATE |
| INVESTIGATE | Store sound source | Path to event, scan | Visual→CHASE; arrived→SEARCH |
| CHASE | Store player location | Pursue updated target with repath throttling | In attack range + LOS→ATTACK; lost LOS for 1.5 s→SEARCH |
| ATTACK | Stop if needed | Wind-up; hit check; cooldown | Target moved out of range→CHASE; lost LOS→SEARCH |
| SEARCH | Store last seen position | Move to location, sweep for 6 s | Reacquire→CHASE; timeout→RETURN |
| STUNNED | Stop and cancel attack | Play feedback, no attack or movement | 1.5 s elapsed→SEARCH/RETURN |
| RETURN | Set nearest waypoint | Resume route smoothly | Arrived→PATROL; sight/noise can interrupt |

Mandatory transition precedence: death/incapacitation > stunned > visibility/attack > investigation > patrol. Include tests for state changes and invalid transition requests.

### 6.6 Enemy navigation and dynamic doors

- `NavigationAgent2D` moves guard by reading `get_next_path_position()` in physics updates until `is_navigation_finished()`; do not assign player global_position directly as a shortcut.
- Define traversable navigation mesh that does not overlap solid walls. For level maps, use explicit NavigationRegion2D polygons or properly configured navigation tile shapes. Verify in editor and through a manual route test.
- Avoid recalculating paths each frame: throttle dynamic target updates to e.g. 0.2–0.3 s or meaningful distance changes. Prevent jitter by appropriate path/target distance tolerances.
- **Dynamic door problem:** Opening/closing a door must update reachable route logic. Use documented navigation map update/door obstacle strategy; if using navigation obstacles only for avoidance is insufficient for pathfinding, rebake or swap navigation regions / dynamic links deliberately. Do not claim dynamic door pathfinding works until tested.
- If Godot navigation mesh setup is blocked by inconsistent downloaded tiles or engine API differences, a **documented AStarGrid2D fallback for dynamic doors** is acceptable for a working level while keeping a real `NavigationAgent2D` demonstration/test scene. This is an explicit fallback, not a reason to skip navigation tests.
- Guards should not jitter at final waypoint, walk through a closed door, or get stuck indefinitely in a corridor. Use stuck timeout with one planned recovery to last valid waypoint; never teleport enemies visibly.

### 6.7 Combat and gadgets

- Default player non-lethal combat: stun baton, attack telegraph 0.15 s, active window 0.1 s, recovery, 0.55 s total cooldown, enemies stunned 1.5 s.
- Gadget `EMP` on Q: one charge consumed on valid activation, 110 px radius, camera/drone disabled **5 s**, human enemies stunned **2 s**, distinct visual circle/pulse. Cannot activate when charges=0; display feedback.
- Heavy guards resist EMP: only 1 s stun. Enemy ranged pulse only if a safe clear line of sight, no wall penetration, projectile lifetime and collision cleanup enforced.
- Optional escape route always exists; combat should be useful but not mandatory for standard completion. Prevent permanent kill-locking of mission-required NPCs.

### 6.8 Inventory and pickups

- Inventory data model: `keycards: Set[String]` or Dictionary, `emp_charges: int`, `data_chip_collected: bool`, optional medkits as immediate use.
- Collectible identity via unique `pickup_id` stored in checkpoint/save; pickup not recollected after save/load.
- Blue/Red Keycards unlock matching doors; opening a door persists for current level and across saves.
- Items are visible and distinct by color and label, never hidden behind inaccessible decorative collision.

### 6.9 Missions and progression

- Mission manager reads author-validated definitions; objectives express dependencies and completion predicates, not UI-only boolean flags.
- Objective types: `pickup`, `interact_terminal`, `unlock_door`, `reach_zone`, `evade_alarm_for_seconds` (last optional).
- Objective events are idempotent; repeating trigger does not add score or complete twice.
- Mission HUD lists next objective and optional subgoals; game provides on-screen instructional prompt in first level.
- An extraction zone only finishes when objective graph satisfied. Unlock next level in `GameManager`.

### 6.10 Alarm and scoring

- Alarm state `CALM`, `SUSPICIOUS`, `ALERT`, `LOCKDOWN`; alarm increases from detections/camera and decays when hidden after specified delay.
- Lockdown is dangerous but **not a permanent impossible state**: doors critical to completing the level can be reopened via a terminal or timer; define contingency path.
- At level completion calculate: elapsed time, detections, damage taken, alerts raised, EMP used, guards stunned; award Bronze/Silver/Gold based on documented deterministic conditions. Never use unverified online leaderboard.
- Present a short results screen with `Retry`, `Next Mission`, `Main Menu`.

### 6.11 Save/load, checkpoint, settings

- `SaveManager` writes versioned JSON to `user://save_v1.json` through a temp file + rename/replace pattern, with error handling. Store version, current level, checkpoint, health, stamina, inventory, completed objectives, picked item IDs, opened door IDs, options and per-level results. Avoid serializing nodes/Vector2 directly; encode as JSON-safe primitives.
- Validate payload shape/types/coordinate bounds; reject unsupported future schema safely and preserve a backup/invalid file when appropriate. Provide **New Game** and **Continue**. Continue disabled if no valid save.
- Save on checkpoint + level completion; optional manual save from pause. Loading must not duplicate pickups or unlock future levels incorrectly.
- Settings: master/SFX/music sliders, fullscreen/windowed, toggle camera shake, UI scale option if practical. Persist separately from mission saves.
- Pausing must pause simulation while allowing Pause UI to process.

### 6.12 Audio / FX / camera feedback

- SFX categories: footsteps, stun, hit, drone, alarm, keycard, terminal, door, button accept/cancel, mission success.
- `AudioManager` manages buses `Master`, `Music`, `SFX`, supports absent sound files with no errors, avoids playing same SFX dozens of times per second.
- Minimal animation: player move / crouch / stun flash, guard alert, doors slide open, terminal hacking progress, EMP radius burst, health damage response.
- Subtle camera shake on hit/EMP with accessibility toggle; don't make UI unreadable.

### 6.13 Menus and onboarding

- Main Menu: New Game, Continue (when available), Settings, Credits, Quit.
- Pause Menu: Resume, Retry Checkpoint, Settings, Main Menu.
- Credits page: original project, code license, Kenney CC0 source pack list and links, appropriate attribution note (CC0 doesn't require attribution but keep it for transparency).
- Level 1 contains short contextual overlay teaching Move, Crouch, Interact, Stun, EMP, Extraction; overlays dismiss on action and don't block progress forever.
- Game Over offers Retry Checkpoint; repeated death/reload must not duplicate autoloads or leave enemies alive from previous scene.

---

## 7. LEVEL DESIGN — AUTHOR THREE REAL LEVELS

Use an authored tile grid (recommend 32×32 logical cell) plus modular props, not purely random procedural maps. Each `.tscn` scene must be visibly distinct and have a viable route. Suggested level sizes and content are tunable but must retain intended logic. Include a layout diagram and objective graph in `docs/LEVEL_DESIGN.md`.

### Level 01 — ACCESS WING / Tutorial Breach

- Grid approximately **40×24** cells, 2 branching corridors, office, storage room, server lobby and extraction bay.
- Player spawn `(3, 19)` grid. Blue keycard room in NW section. Security terminal mid-center. Exit NE.
- Threats: **2 Patrol Guards**, **1 rotating security camera**; 1 guarded corridor with avoidable path.
- Objectives (strict dependency): `Find Blue Keycard` → `Disable North Security Terminal` → `Reach Extraction`.
- Mechanics: patrol, vision cones, crouch, interaction; optional EMP charge placed in storage.
- Checkpoint: after terminal, before exit. At least two ways to approach terminal (stealth route and direct route).
- Player must see start and a clear first objective. Tutorial instructions must be contextual rather than long modal exposition.

### Level 02 — RESEARCH VAULT / Retrieval

- Grid approximately **48×30**, hub with 3 branches, access-locked lab, drone shaft, research vault.
- Threats: **3 Patrol Guards**, **1 Heavy Guard**, **2 cameras**, **1 drone**.
- Objectives: `Get Red Keycard` → `Hack Vault Terminal (3 seconds with cancel)` → `Collect Data Chip` → `Unlock Escape Corridor` → `Extract`.
- Introduce noise lure/interruption and one EMP pickup. Alarm can temporarily seal optional shortcut but cannot permanently block route.
- Checkpoint after chip; saved opened door and pickup state persist.
- Make patrol routes and line-of-sight obstacles intentionally designed for different strategies.

### Level 03 — BLACKOUT ESCAPE / Finale

- Grid approximately **52×30**, industrial floor, maintenance tunnel, power control, final checkpoint, exit airlock.
- Threats: **3 Guards**, **2 Heavy Guards**, **2 Drones**, **2 cameras**. Don't spawn more than performance target without design purpose.
- Objectives: `Restore Auxiliary Power` → `Override Lockdown` → `Reach Exit Airlock`.
- Introduce a timed pressure sequence (e.g. 90 seconds after override) but allow an alternate retry/checkpoint. No unwinnable save made at 1 second left; time resets appropriately on checkpoint retry.
- Optional finale branch: escaped undetected result message vs detected result message, both count as completion. No need for cinematic asset.
- End with a `MISSION COMPLETE` results screen, total run summary and credits.

### Test Arena — DEV ONLY

- A rectangular map with 1 guard, 1 heavy, 1 drone, obstacles, a closed/openable door, test pickup, projectile wall, checkpoint, terminal and detection debug visualization.
- Access via `--scene res://scenes/levels/test_arena.tscn` or editor, NOT visible from release menu.
- Include a stress toggle to activate 10/20/40 agent instances for profiling; log actual conditions when collecting measurements. Debug/test arena must not alter production mission saves.

### Level design acceptance checks

- Walkable routes valid from spawn to every mandatory objective and extraction under normal conditions.
- Keycard and terminal always reachable; relevant doors initially locked/unlocked as intended.
- Player cannot walk outside map or through walls. Guards cannot see through walls. Camera can't spot someone behind walls.
- Closed door affects physics and AI navigation; opened door changes both.
- Checkpoints reload into a valid state; alarms may continue according to saved design, but never trap a checkpoint permanently.

---

## 8. ART DIRECTION & UI SPECIFICATION

### 8.1 Palette / visual design

Use hex palette consistently: background `#0B1421`, wall `#243444`, floor `#162635`, primary cyan `#43D9E8`, secondary teal `#1DBFAF`, warning amber `#FFB454`, alarm red `#F56B73`, text `#E7F0F5`, muted `#96A8B8`. Respect silhouette readability over ornamental detail.

- Distinguish interactables visually using outline/indicator; the E prompt must appear within reach.
- Guard cones translucent amber in debug; only optionally show an in-world simplified alert marker during normal game to avoid giving perfect enemy info.
- Text minimum readable at 1280×720; avoid tiny 6-pixel lettering in critical prompts.
- Text and icons should not look out of place beside pixel art; if art styles conflict, fall back to uniformly styled procedural art until coherent.

### 8.2 UI states

- Main Menu active/hover/disabled/focus state; controller support optional.
- HUD: Health, Stamina, EMP charges, keycards, objective text, Alarm state, interaction prompt.
- Hack progress displays 0–100%, cancels if hurt/out of range, never silently completes while paused.
- Settings have visible audio values, apply/reset, and Back navigation.
- End screen displays stats and optional grade with consistent thresholds.
- Responsive window resizing: maintain 16:9 aspect with bars and anchor HUD to edges.

### 8.3 Animation budget

Required (procedural counts if missing sprite sheet): player idle/walk/attack/hurt, guard patrol/alert/attack/stun, door open, terminal hack, drone scan, camera sweep, EMP burst, pickups hover. These are specific visible state changes, not just variable names.

---

## 9. DEVELOPER OVERLAY — ESSENTIAL FOR INTERVIEW

Toggle with F3 on development builds. Ensure debug draw/overlay is disabled in export release unless explicitly enabled with a config flag.

Required overlay fields:
- FPS (`Engine.get_frames_per_second()`), physics frame count or time, level ID, player position/velocity, health/stamina.
- Enemy count per state; currently nearest enemy's `state`, `detection_progress`, `last_seen_position`, `current_path_length`.
- Active projectile count; pickup count; alarm state; audio sources playing (optional).
- Render guard FOV edges/cones, LOS rays that stop on world collision, navigation paths/waypoints, patrol markers, noise event radius, door collision state. On-screen display must reflect true underlying values, not hard-coded visuals.
- Fixed-size ring buffer of 50 debug events (`timestamp, actor_id, from_state, to_state, reason`) viewable in a simple panel and printable to logs.
- Optional separate `docs/debug_session_samples/` logs only if actually generated; avoid committing personal filesystem paths.

Include clearly documented reproducible debug scenarios:
1. Enemy should not detect through a wall.
2. Enemy should not be stuck after closed door opens.
3. Attack overlap causes at most one hit per swing.
4. Repeated pause/resume and reload does not create duplicate alerts or entities.
5. Detection goes CHASE→SEARCH→RETURN→PATROL after LOS is lost.

These scenarios must be **tested**, not intentionally shipped as existing bugs. `docs/DEBUGGING_CASE_STUDIES.md` must separate **hypothesized failure modes**, **actual reproduced issues**, **fix**, **before/after evidence**.

---

## 10. TESTING STRATEGY — AUTOMATED + MANUAL

### 10.1 Zero-dependency test harness

Implement a runnable `tests/run_tests.gd` extending `SceneTree`. Each test method validates state with explicit assertions and returns structured success/failure counts. Exit the process with **0 on success** and **non-zero on failure**. Avoid using only `assert()` if release/dev settings may bypass it; make explicit checks. Automated tests should not require a graphical display or sound. Use mock scene/test doubles where necessary, but also include real scene integration tests.

Required command (after import):

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Project import/parser smoke:

```bash
godot --headless --path . --editor --import
godot --headless --path . --quit-after 120
```

On Mac when `godot` isn't in PATH, use the actual downloaded `.app/Contents/MacOS/Godot` executable. Do not say these commands passed unless executed.

### 10.2 Automated test cases (minimum)

| Test ID | Scenario / expected |
|---|---|
| T01 | Walking diagonal normalization matches straight movement speed |
| T02 | Sprint drain stops at zero, regen bounded and delay obeyed |
| T03 | Crouch speed lower, hearing noise not equal to sprint |
| T04 | `apply_damage(-1)` ignored; zero HP emits exactly one death |
| T05 | Invulnerability prevents repeated rapid player damage |
| T06 | An attack hitbox damages/stuns one target at most once per swing |
| T07 | Enemy idle patrol transitions on noise to investigate |
| T08 | Enemy LOS blocked by wall, even within radius/FOV |
| T09 | Enemy LOS outside FOV cannot detect player |
| T10 | Chase loses target → search → return → patrol after timeout |
| T11 | Stun cancels attack and releases control after timer |
| T12 | Alert event propagation deduplicated by event ID |
| T13 | Keycard cannot be collected twice |
| T14 | Locked door rejects missing keycard and opens with matching keycard |
| T15 | Terminal interaction cancels when player leaves range |
| T16 | Mission objective rejects missing prerequisites, complete once |
| T17 | Extraction blocked before mandatory objectives completed |
| T18 | Save JSON roundtrip preserves inventory / checkpoint / doors / pickups |
| T19 | Invalid/corrupt/unsupported future-version save fails safely |
| T20 | Level 1, 2, 3 required paths and references are valid |
| T21 | Restart level doesn't spawn duplicate player / autoload listeners |
| T22 | Pause stops simulation timers, pause UI still works |
| T23 | EMP consumes one charge, stuns valid entities once, ignores invalid target |
| T24 | Enemy projectile/attack blocked by solid wall |
| T25 | Reaching finale with required objectives triggers results once |

Recommended additional tests: JSON migration handling, all game menus instantiate in headless mode, active enemy count doesn't leak after scene change, collision layer matrix matching docs, interaction priority. Some physics and navigation behavior requires scene integration or manual tests: document which mode executed.

### 10.3 Manual playtest checklist

- Play from main menu through all 3 levels using keyboard and mouse.
- Retry after death; load checkpoint; close/relaunch; Continue resumes at expected state.
- Collect multiple keycards; open door; walk through; enemy follows only where it should.
- Let guard see player → escape behind wall → observe search and return.
- Test camera detection behind a wall; EMP-disable/re-enable.
- Test high-stress scene; reduce shadows/visual debug and compare FPS.
- Test window resize, settings, focus, alt-tab/back-to-game, audio volume persist.
- Ensure no red errors in Godot debugger during a full level playthrough.

### 10.4 CI

Create `.github/workflows/godot-ci.yml` pinned to an actual verifiable Godot 4.7.2 executable/artifact and running on PR/push. Avoid pointing to a nonexistent container image. CI must:
1. Checkout repository.
2. Install/download editor in a verified way (e.g. official 4.7.2 release URL resolved/checked, not a guessed host).
3. Verify `godot --version` is correct.
4. Run import.
5. Run `tests/run_tests.gd`, fail on non-zero exit.
6. Perform parser/game smoke headless and capture logs.

If installing an exact engine version in CI is blocked, do not add a broken pretended-success workflow. Provide setup steps and clearly mark CI as blocked.

---

## 11. PERFORMANCE & RELIABILITY

Test on the user's reasonable target: **Apple Silicon Mac M1 with 16 GB RAM**. Do not fabricate FPS. Engineering targets:
- Target 60 FPS at reference view for default levels on M1; measure if hardware is accessible.
- Target no visible 1-second hitch on level transitions after initial load; count hitches using real profiling data.
- 10 simultaneously active guards and a handful of projectiles should not cause sustained frame drops in ordinary scenes; stress scene explores 10/20/40 agents and records results, not a pass assumption.
- Avoid per-frame expensive raycasts against every scene entity: only scan near candidates, time-slice high-cost perception for offscreen actors where reasonable.
- Pool or limit common effects/projectiles; dispose animations/tweens and audio nodes as needed.
- Keep navigation target updates throttled and guard against recalc storms.
- Avoid background processes in paused scenes and repeated signal connections across reloads.
- Keep initial repository/assets under a pragmatic size (prefer <150 MB before any release binaries); do not bundle archives + duplicates.

`docs/PERFORMANCE.md` must include test platform, build/version, number of enemies, resolution, data collection method, measured before/after FPS or frame time, observed bottlenecks, actual changes. If no run, document `NOT MEASURED`.

---

## 12. AUDIO, ART AND LICENSE ACCEPTANCE

- Every third-party file committed to repo appears in `docs/ASSET_INVENTORY.csv` with source, license, original file path and SHA-256; generated original shapes/PNG listed as own work.
- All direct third-party audio/tiles/UI must be legal to redistribute. The selected Kenney pack pages show CC0; preserve source and license docs.
- Asset normalization must not silently rescale pixel art with blurry linear filtering.
- Missing optional audio, image or shader must not crash the project. No hard references to absent external packs.
- `docs/ASSET_SOURCES.md` must contain exact upstream product page URLs, asset license and whether the asset has been included; do not claim a pack was used if it was not.
- No recognizable logos, characters or UI stolen from commercial games. All fictional brand labels within Shadow Protocol are original.
- Preview screenshots and GIFs must be produced from actual Godot output, not image mockups or AI-generated screenshots presented as gameplay.

---

## 13. IMPLEMENTATION ROADMAP — MANDATORY SEQUENCE, NO SKIPPED STAGES

For each stage, create relevant code, run applicable headless checks, record verification and any blockers in `IMPLEMENTATION_STATUS.md` and proceed if the stage's blocking conditions are resolved. On technical failure, fix rather than declaring victory.

### Stage 0 — Prerequisite audit

**Deliver:** current repo inventory; `godot --version` (or actual executable path); documented engine availability; source asset inventory; git repo; `.gitignore`; directory skeleton and status log.

**Pass:** correct engine detected or accurately flagged as unavailable; no destructive modifications; initial project and planned stages recorded.

### Stage 1 — Bootable Godot app with safe visual fallback

**Build:** project settings/input map, autoload services, main menu (functional New Game / Settings / Quit), first level, pixel grid/collisions/player basic movement, camera, a clean UI theme. Use original procedural art until verified downloads are prepared.

**Pass:** Godot editor imports without parse errors; game shows main menu; New Game enters level; WASD moves with solid-wall collision; Quit and menu work; no missing-resource errors.

### Stage 2 — Asset validation and art integration

**Build:** `tools/asset_inventory.py`, asset mapping JSON, licensed selection/normalization, character/enemy/environment and UI renderers that use assets when mapped and fallback otherwise. Set filtering and proper region/atlas rects only after actual inspection.

**Pass:** no unsupported license files included; all resources resolve; documented asset map points to real files; game still launches without `incoming_assets/` present.

### Stage 3 — Player systems, interaction and UI

**Build:** movement, sprint/crouch/stamina, health, attack, pickups/keycards, doors and terminal, HUD prompts, hit feedback, animations, audio fallback.

**Pass:** scenario tests T01–T06, T13–T15 and keyboard/manual smoke pass; one sample objective functions end-to-end.

### Stage 4 — Enemy FSM and sensing

**Build:** guard with PATROL, SUSPICIOUS, INVESTIGATE, SEARCH, CHASE, ATTACK, STUNNED, RETURN; directional vision; hearing; simple guard navigation; alarm events.

**Pass:** scenarios T07–T12; debug display shows actual FSM transitions; enemy stops at walls and respects LOS. Run patrol/vision/LOS scenes manually.

### Stage 5 — Combat, EMP, heavy guard, drone/camera

**Build:** nonlethal combat, enemy attacks, heavy variant, drone perception, camera sweep/EMP disable, projectile collision, object cleanup and audio/VFX.

**Pass:** T23–T24, repeat attack hitbox, wall safety; repeated EMP doesn't leave camera permanently offline; no immortal enemies.

### Stage 6 — Three missions and progression

**Build:** all three levels, objective graphs, scripted interactions, checkpoints, alarm/lockdown and extraction. Provide reproducible testing path for each.

**Pass:** all mandatory objectives can be reached and completed. Finish all 3 levels from New Game without developer teleport. Results screens advance correctly and persist progress.

### Stage 7 — Save, load, settings, menus

**Build:** versioned save and corrupt-file handling, pause/settings/new/continue/game over/results, mission stats, complete credits and source information.

**Pass:** T18–T22, save restore, forced corrupt save and relaunch, retry and scene reload don't duplicate actors.

### Stage 8 — Debug overlay and reproducible scenarios

**Build:** F3 panel + drawing for LOS, detection, paths, noise radii, collision, enemy states; dev arena with stress toggles; bounded event log.

**Pass:** debug values correlate with real runtime; overlay toggle doesn't alter AI logic; test arena is separately launchable.

### Stage 9 — Automated testing, CI and stabilization

**Build:** complete 25+ tests, `tools/validate_project.sh`, GitHub Actions workflow (only if source is verified), crash/error fix pass; benchmark report.

**Pass:** all executable automated tests pass locally; regular gameplay runtime observed; all untested items clearly labeled. No fabricated results. When Godot is unavailable, mark this stage blocked rather than green.

### Stage 10 — Portfolio polish

**Build:** stronger visual identity using selected consistent assets, UX polish, tooltips/tutorial, README with real screenshots, video guide, architecture diagrams, debug write-up, short recruiter pitch.

**Pass:** a new developer can clone and run using README; screenshots are real; 5–8-minute interview path works.

### Stage 11 — Packaging and handoff

**Build:** release export presets, packaged desktop builds (only for platforms that can be exported), final `IMPLEMENTATION_STATUS.md`, asset licenses, changelog, clean git repo.

**Pass:** clean clone imports and launches; export path works if templates available; report exact generated build paths and checksums. Explicitly list not completed/blocked areas.

---

## 14. EXACT ASSET-TO-GAME ADAPTATION RULES

When actual licensed pack images are available, construct the following mapping by VISUAL/AUTOMATED INSPECTION, not guesses. Use the manifest to preserve origin:

| Logical asset key | Preferred source | Fallback if source lacks suitable art | Required function |
|---|---|---|---|
| `player_body` | Top-down Shooter relevant character sprite | Original cyan body + heading wedge | Visible player + direction |
| `guard_body` | Top-down Shooter relevant character sprite | Original orange uniform body | Guard visible / independent from player |
| `heavy_body` | Top-down Shooter suitable character | Larger plated orange/red silhouette | Visibly armored |
| `drone_body` | Sci-Fi RTS *only if same top-down perspective* | Original polygonal hover robot | Patrol/drone recognition |
| `floor_tile` | Top-down Shooter tile/floor | Original 32×32 grid patterned tile | Readable walkable floor |
| `wall_tile` | Top-down Shooter wall candidate | Original solid wall/block | Clear obstruction + collision |
| `door_open/closed` | Appropriate pack candidate | Original animated rectangular door | Visible lock state / collision |
| `terminal` | Sci-Fi RTS candidate *if perspective matches* | Original cyan console + glow | Hack/disable target |
| `keycard_blue/red` | Game Icons candidate | Original keycard polygons/icons | Clear colored pickup |
| `data_chip` | Game Icons candidate | Original diamond microchip | Mandatory mission item |
| `emp` | Game Icons candidate | Original circular electric icon | Charge count and effect |
| `ui_button/panel` | UI Pack - Sci-Fi | Native Control + StyleBoxFlat | Working menus / HUD |
| `sfx_hack/alert/door` | Sci-Fi Sounds | silent / synthesized original pulse | Audio feedback when installed |
| `sfx_click/confirm` | Interface Sounds | native click feedback only | UI navigation |
| `sfx_hit` | Impact Sounds | flashing/hit VFX without sound | Combat response |
| `menu_sting/victory_sting` | Music Jingles (select suitable clip) | silent | Optional short transition |

**Slicing requirements:** Do not hardcode `32x32` source texture if the source sheet uses different dimensions. Compute actual PNG dimensions and manually confirm the region layouts. Use **game tile size 32×32** as a logical map unit, not as an assertion about art file dimensions. When scaling low-resolution sprites, use integer scale and nearest filtering if appropriate.

**Cohesion check:** all characters should appear correctly top-down and sized similarly relative to doors; don't mix side-on soldiers with isometric buildings. If a pack fails the cohesion check, don't use that pack in gameplay simply to satisfy a download checklist.

---

## 15. GODOT TOOL COMMANDS, SMOKE VALIDATION AND EXPORTS

### 15.1 Local prerequisites (macOS Apple Silicon)

1. Download **Godot 4.7.2 stable / macOS Universal / Standard** from https://godotengine.org/download/archive/4.7.2-stable/. Do **not** select .NET unless using C# (this spec is GDScript only).
2. Unzip and move `Godot.app` to `/Applications/` if desired. On macOS, allow the application through OS security settings if prompted by a legitimate downloaded/signed app. Do not disable system security globally.
3. Find the engine command executable. If installed at the conventional path:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --version
```

4. Optional terminal alias for the current shell: `alias godot='/Applications/Godot.app/Contents/MacOS/Godot'`. Confirm with `godot --version` after alias assignment. If actual `.app` name differs, use actual location.
5. In GitHub project root, open the folder in Godot Project Manager using **Import** and choose `project.godot`; let it finish resources import.

### 15.2 Validation workflow

```bash
# From repository root. Replace `godot` with the full macOS executable path if needed.
godot --version
godot --headless --path . --editor --import
godot --headless --path . --script res://tests/run_tests.gd
godot --headless --path . --quit-after 120
# Visual verification (mandatory when an interactive desktop is available):
godot --path .
```

`--quit-after` is a smoke startup test, **not** proof the level is playable. To validate Godot script parsing more explicitly, use editor import and the Godot stdout/stderr with exit codes. Tests must run in a mode that lets failures return non-zero.

### 15.3 Export settings

- Project → Export → install official export templates matching **4.7.2** → Add presets for macOS, Windows Desktop and Linux (subject to actual platform tooling). Export scene/resource dependencies as needed.
- Commit `export_presets.cfg` when it contains no sensitive info. **Never** commit `.godot/export_credentials.cfg` or signing passwords.
- Recommended output locations `builds/macos/`, `builds/windows/`, `builds/linux/` in ignored build folder. Source repository always includes `project.godot`.
- Test launch of an actual built executable if generated; if you cannot run an OS-specific build, label that export `BUILT, NOT RUN-TESTED`.
- Release artifacts and screenshots require a separate real generation step; do not create a README download link until the file exists.

### 15.4 Suggested `.gitignore`

```gitignore
.godot/
*.tmp
*.log
.DS_Store
incoming_assets/
builds/
dist/
.cache/
__pycache__/
.pytest_cache/
```

Note: `.godot/` contains editor import/cache data; keep `project.godot`, `.tscn`, `.tres`, project scripts and relevant source resources version controlled. Do not ignore actual `assets/` content used by scenes.

---

## 16. ENGINEERING QUALITY AND EDGE CASES

### Code robustness

- Avoid long methods: separate movement/perception/state transitions/attack handling and UI binding. Prefer no file above ~400 lines without architectural reason.
- All asynchronously finishing interactions/tweens must verify actor and scene still exist (`is_instance_valid`) and cancel safely on scene switch.
- Handle no enemy player reference on scene teardown; handle detection when target dead.
- Avoid repeated signal connections during checkpoint reloads and double instantiation of global services.
- Limit tweens/timers created per frame; schedule rechecks intentionally.
- Input handling must use event vs held-input appropriately (E once vs WASD held).
- Save manager validates fields and unexpected values before applying game state.
- Enemies cannot attack through a wall even if their navigation status says near target.

### Balance and fairness

- Always show readable security camera sweep and red alarm warning.
- Player is never placed in unavoidable instant detection during respawn; grant short grace window when spawning if needed.
- Mandatory mission pickups do not spawn inside inaccessible collision or under HUD-only modal.
- Every locked path has a real obtainable keycard/terminal unlock or alternate route.
- On final timer failure, retry available without corrupting checkpoint.

### Scope guardrails

Do not overbuild network/multiplayer, procedural generation, 3D open world, microtransaction systems, account login, online leaderboard, mobile control overlays or marketplace integrations. Finish the polished 2D game first.

Optional **3D expertise demonstration after all required gates:** a tiny separate `scenes/3d_demo/` playable room using `CharacterBody3D`, `NavigationAgent3D`, `AnimationPlayer`, `Control`, debug camera and primitive meshes. Explicitly label it `EXPERIMENTAL 3D TECH DEMO`. It must not be a substitute for required levels or degrade the 2D game. Do not claim professional 3D experience from one toy scene.

---

## 17. GITHUB RECRUITER EXPERIENCE & DOCUMENTATION

### README.md (English; in this exact rough order)

1. Project name + short hook and **real** hero gameplay screenshot (if available).
2. A clear 1-paragraph feature pitch, 15–25-min gameplay length and key controls.
3. `Watch Demo` link only if a real recording exists; real GIF/screenshots stored in `docs/screenshots/`.
4. `Play` section with real build links only if verified; no dead links.
5. `Run from source` with Godot **4.7.2 stable** and Mac/Windows/Linux import steps.
6. Tech stack: GDScript, CharacterBody2D, TileMapLayer, NavigationAgent2D (if truly used in core), finite-state machines, RayCast2D, Area2D, Resources, FileAccess, audio buses.
7. Systems architecture diagram or simple Mermaid (no proprietary images necessary).
8. `Debugging & Performance` with reproducible scenarios and factual measured data, if obtained.
9. Testing commands and CI badge only if CI runs successfully.
10. Project directory map and license/asset credits (explicit Kenney source links).
11. Honest development notes: role of AI-assisted coding if used, features fully implemented, known gaps and learning outcomes.

### `docs/REPRODUCE_WORKFLOWS.md`

Prepare 5 short human-executable workflow scripts suitable for a technical interview. For EACH workflow include `Goal`, `Starting state`, `Actions in Godot Editor` (click paths and file names), `Reason`, `Expected observation`, `How to verify`, and `Reset`. Scenarios:

1. Create/modify Patrol to Chase to Search transitions.
2. Debug a guard spotting the player through a wall using collision mask and LOS ray.
3. Change wall/door collision and regenerate/verify navigation route.
4. Profile stress arena with 10/20/40 guards and compare actual frame times.
5. Add a new hack terminal interaction, UI label and mission objective using reusable components.

Make instructions accurate for the implemented scene tree; don't write generic tutorial steps that can't be followed in this project.

### `docs/DEBUGGING_CASE_STUDIES.md`

Use real issue records when available, with `symptoms → reproduce → root cause → evidence → fix → regression test`. Do not invent incidents or before/after measurements. If no real defect observed, provide `POTENTIAL DEBUGGING CHALLENGE (not a production bug)` with a prepared test sandbox and expected correct behavior.

### `docs/VIDEO_CAPTURE_GUIDE.md`

3–6 minute technical demo runbook:
- 0:00–0:30 menu + mission premise and controls.
- 0:30–1:15 player movement / crouch / interaction.
- 1:15–2:00 enemy patrol + vision/LOS + alarm.
- 2:00–2:45 stun + EMP + locked door + objective.
- 2:45–3:45 F3 AI state/path visualization and test arena bug scenario.
- 3:45–5:00 save/load + tests & architecture overview.
- 5:00–6:00 results + repo/docs summary if recording duration allows.

Only use this guide for a **real capture**. Don't create a fake gameplay demo using unrelated footage.

### Candidate profile line (only after implementation)

`Built Shadow Protocol, a modular stealth-action Godot game with GDScript-based enemy state machines, raycast perception, physics interactions, save/load, debug visualization and automated scene tests.`

---

## 18. RELEASE QA / OBSERVABILITY MATRIX

| ID | User-facing behavior | Functional proof | Required status |
|---|---|---|---|
| A01 | New Game launches level 1 and teaches controls | Real gameplay capture / smoke | PASS |
| A02 | 8-way motion, sprint, crouch, wall collision | Tests + manual play | PASS |
| A03 | Enemy patrol/pathing works around walls | Debug overlay + manual | PASS |
| A04 | Enemy vision blocked by walls, FOV and range | Tests + visual LOS | PASS |
| A05 | Hearing investigate + Chase/Search/Return transitions | FSM tests + debug event log | PASS |
| A06 | Attack / stun / EMP functional and non-duplicating | Combat tests + visual | PASS |
| A07 | Security camera sweeps, alarm, temporary disable | Manual + integration | PASS |
| A08 | Keycard/door/terminal/pickup interactions | Interaction tests + manual | PASS |
| A09 | Level 1–3 playable from start to extract | Manual full completion | PASS |
| A10 | Extraction refuses premature entry | Mission test | PASS |
| A11 | Save/load/checkpoint including corrupt-file behavior | Tests + relaunch | PASS |
| A12 | Menu, Pause, Settings, Results, Credits | Scene smoke/manual | PASS |
| A13 | HUD and Developer Overlay show true runtime state | Manual inspection | PASS |
| A14 | Sound fallback does not crash when absent | No-asset headless smoke | PASS |
| A15 | Asset inventory/license provenance complete | Inventory audit | PASS |
| A16 | 25+ automated tests (or explicit blocked cases) | CLI process exit | PASS for final accepted game |
| A17 | Clean `godot --editor --import` + game startup | CLI process exit/log | PASS |
| A18 | README and real screenshots + working steps | Clone/install audit | PASS |
| A19 | Release export when compatible templates exist | Verify export files | CONDITIONAL |
| A20 | Measured perf numbers, never guessed | Actual logs on available hardware | CONDITIONAL |

**Release blockers:** A01–A18 are mandatory. A19–A20 can be labeled BLOCKED only with exact reason and alternative verification; user can decide whether to publish before solving those issues. A developer should not silently lower quality gates.

---

## 19. AGENT REPORTING / HANDOFF FORMAT

After each stage, update `IMPLEMENTATION_STATUS.md` using:

```markdown
## Stage N — [Title]
Status: PASS | FAIL | BLOCKED | PARTIAL
Implemented files: [actual paths]
Validation commands: [commands actually run]
Results: [real exit code, observed outcome, relevant log path]
Manual checks: [performed / not performed and reason]
Known issues: [real unresolved issues]
Next stage: [specific]
```

In the final reply to the user, provide:
- What is **actually playable** and how many levels are actually completed.
- Exact path to `project.godot` and command to run.
- How to set up/update assets using the separately provided Vietnamese guide.
- Tests actually executed, pass/fail counts, and commands.
- Optional export build paths only if the files exist.
- Explicit limitations/human verification tasks (e.g. manual Godot review of navigation, asset downloads, real gameplay capture).
- Git changes and the next sensible improvement.

**Do not claim game is finished solely because source files were written.** Import, run and playtest are essential.

---

## 20. FINAL CODING AGENT PRIORITY / DECISION TREE

1. **Can Godot run?** Yes → set version + import / tests. No → attempt safe documented installation or flag inability and continue generating legitimate sources.
2. **Are Kenney downloads present?** Yes → inventory, license, visually verify mapping, integrate. No → original procedural assets and an actionable user download checklist; never block gameplay.
3. **Is first level playable?** No → stop adding features and fix basics. Yes → next system.
4. **Are AI perception/pathing correct?** No → fix before adding more enemy types.
5. **Can every level be completed from spawn?** No → fix objective/nav route, do not add polish.
6. **Does saving/reloading preserve consistent mission state?** No → fix before demo.
7. **Does headless test suite exit 0?** No → fix or list exact unblocked failures; do not call complete.
8. **Are README screenshots from actual game?** No → take real screenshots or omit them; no mockup impersonation.
9. **Does a public repository carry only legally reusable assets?** No → remove/rework unlicensed content.
10. **Do final quality gates A01–A18 pass?** Yes → prepare releases/documentation. No → report partial completion.

**Agent instruction:** Implement the complete game according to this spec. Use iterative edit → Godot import → test → manual evaluation → fix cycles. Prefer real working mechanics and honest checks over large quantities of untested code.

---

## 21. VERIFIED REFERENCE LINKS (official sources)

**Godot**
- Godot 4.7.2 official archive (macOS Universal Standard included): https://godotengine.org/download/archive/4.7.2-stable/
- Godot official command-line guide: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- Godot TileSets/TileMapLayer documentation: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilesets.html
- Godot exporting projects: https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
- Godot NavigationAgent2D reference: https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html

**Kenney / CC0**
- https://kenney.nl/assets/top-down-shooter
- https://kenney.nl/assets/sci-fi-rts
- https://kenney.nl/assets/ui-pack-sci-fi
- https://kenney.nl/assets/sci-fi-sounds
- https://kenney.nl/assets/interface-sounds
- https://kenney.nl/assets/impact-sounds
- https://kenney.nl/assets/game-icons
- https://kenney.nl/assets/music-jingles

**License context**
- CC0 legal summary: https://creativecommons.org/publicdomain/zero/1.0/
- Godot demo projects (reference only; do not blindly copy assets): https://github.com/godotengine/godot-demo-projects

**Note:** External URLs are source pages verified when spec was prepared; download button endpoints and archive internal filenames can change. Validate at actual download time. Never invent a direct ZIP URL or import missing assets by name alone.
