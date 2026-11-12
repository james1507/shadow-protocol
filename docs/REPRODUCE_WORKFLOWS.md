# Five reproducible engineering workflows

## 1. Patrol → Chase → Search

**Goal:** inspect actual eight-state transitions.
**Starting state:** import project.godot; open scenes/levels/test_arena.tscn, F6.
**Actions in Godot Editor:** open scripts/enemies/enemy_controller.gd; inspect update_sensing and transition. Run scene, F3; walk into guard's facing cone, wait for confirmation, then leave behind central wall. Use PageUp/PageDown for history.
**Reason:** suspicion, confirmed sight, lost sight and timeout have separate timers.
**Expected observation:** PATROL → SUSPICIOUS → CHASE; after lost LOS SEARCH, after six seconds RETURN, then PATROL. Stun temporarily overrides all movement.
**How to verify:** live nearest-enemy state/path/detection and AI_EVENT logs; T07/T10/T11/T27.
**Reset:** stop F8, run F6; no production save changed.

## 2. Wall-blocked vision

**Goal:** distinguish FOV broadphase from actual collision ray.
**Starting state:** test_arena running with F3.
**Actions in Godot Editor:** open scripts/enemies/vision_sensor.gd and scripts/world/level_controller.gd clear_los; inspect world query mask 1. Move player to opposite side of central wall from guard; use Remote scene tree to inspect World/Walls collision enabled state.
**Reason:** distance and angle alone do not occlude walls.
**Expected observation:** amber cone clips at wall; red LOS ray stops on world collision; detection does not rise through wall.
**How to verify:** T08 builds this exact physical condition; inspect ray terminal positions and detection.
**Reset:** restore query mask 1 if modified; rerun validate_project.sh.

## 3. Door collision and route changes

**Goal:** verify AStar fallback changes with real doors.
**Starting state:** arena F6; open scripts/world/grid_world.gd set_door and scripts/interactables/interactable.gd open_door.
**Actions in Godot Editor:** approach central test_door, press E; inspect Remote Interactables/test_door/StaticBody2D/CollisionShape2D disabled state. F3 displays closed/open door footprint. Inspect the heavy guard's real NavigationAgent2D demo route separately in right room.
**Reason:** avoidance obstacles alone cannot change topological reachability; production explicitly edits AStar cells.
**Expected observation:** two-cell closed footprint blocks route and body; open removes both. Heavy demo route stays inside its clear NavigationRegion2D.
**How to verify:** T14 + T26; move through opening and observe no collision. Production maps deliberately use AStar, not claimed navmesh door rebaking.
**Reset:** stop/run arena; door starts closed.

## 4. Stress measurement

**Goal:** collect reproducible frame times with 10/20/40 agents.
**Starting state:** arena F6, F3 off; Godot bottom panel Debugger → Monitors and Profiler.
**Actions in Godot Editor:** press F4 to cycle 10, 20, 40, 3 guards. In Profiler click Start, sample several seconds for each count. For scripted matching measurements run `godot --path . --script res://tools/benchmark.gd`.
**Reason:** disclose actual agent count/resolution/debug state and separate capped FPS from CPU cost.
**Expected observation:** STRESS log reports count; profiler shows real physics/script timings, not hard-coded stats.
**How to verify:** docs/benchmark.json and docs/PERFORMANCE.md; rerun on target M1 before claiming M1 performance.
**Reset:** stop/run arena. Scripted benchmark rewrites only its report, never mission save.

## 5. Add a hack terminal objective

**Goal:** reuse existing interaction convention and HUD dependency display.
**Starting state:** duplicate data/missions/test_arena.json as a local backup outside res://; open that JSON in editor text view or external editor.
**Actions in Godot Editor:** add objective `{ "id":"new_hack", "title":"Disable test relay", "requires":["security"] }`; add object `{ "id":"relay", "kind":"terminal", "cell":[22,17], "key":"", "objective":"new_hack" }`. Open scenes/interactables/terminal.tscn to inspect shared script/Area2D. F6 arena; hack original terminal, then new relay.
**Reason:** authored JSON determines identity/prerequisites; one scene provides LOS/range/timing/cancellation; HUD derives next title from same mission graph.
**Expected observation:** new terminal appears at exact cell, refuses early hack, then completes once after three seconds. HUD updates automatically.
**How to verify:** inspect mission.completed in Remote tree, attempt repeated E; no duplicate completion.
**Reset:** restore original JSON; rerun import and tests. Arena never touches campaign saves.
