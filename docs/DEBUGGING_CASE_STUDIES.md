# Debugging case studies

## Actual defect: card objective substituted for inventory authorization

Symptom: T14 initially failed; removing Blue card from inventory still allowed its door to open after pickup objective had completed.
Reproduce: collect card, clear inventory in focused test setup, interact with north door.
Root cause: a single authorization expression accepted a key from either inventory or completed objective IDs; `blue` existed in both namespaces.
Evidence: initial suite 27 pass / 1 fail at T14; recorded in implementation status.
Fix: color keys require actual inventory membership; power/vault/override locks require completed terminal objectives.
Regression: T14 checks rejection without card, success with card, and both door navigation cells changing.

## Actual defect: eager script dependencies under SceneTree --script

Symptom: initial test runner printed `Identifier not found: EventBus` and `GameManager` despite normal project startup succeeding.
Reproduce: runner statically typed gameplay classes at parse time.
Root cause: dependent gameplay scripts compiled before autoload global names were available in custom --script initialization.
Fix: standalone harness loads gameplay classes at runtime after initialization. Game remains normally typed.
Regression: full CLI runner executes independently and exits with structured results; watchdog catches initialization stalls.

## Actual UI defects found in graphical review

Symptom: Quit below bottom edge; schematic right panel blank; HP bars overflowed header.
Root cause: default StyleBox content margins increased button/bar minimum sizes; child background covered parent's custom drawing.
Fix: compact button margins, zero progress-bar margins, background drawn in same _draw before schematic.
Evidence: subsequent actual desktop review and docs/screenshots/menu.png show all five buttons; gameplay screenshot shows bounded bars.

## Actual packaging gate

Symptom: Apple Silicon export refused universal target while ETC2/ASTC imports disabled.
Fix: enable `rendering/textures/vram_compression/import_etc2_astc`, reimport, rerun actual export.
Outcome recorded in release logs/status, not assumed from editing configuration.

## Test-driver issues, not game bugs

First bot stalled at a waypoint because stop radius and per-axis deadzone disagreed. A second attempt inspected current_scene before deferred scene switch completed. A scaled watchdog timed out early because its timer inherited 4x simulation time. Driver now uses consistent tolerances, scene_changed, and a real-time watchdog. A canceled vault-area hack required legitimate EMP/retry handling. No game movement or AI was disabled to force completion.

## Potential debugging challenges (not shipped bugs)

- Change LOS query mask from 1 to 0; T08 should fail. Reset mask before committing.
- Remove one AStar door-cell update; T14 and dynamic route review should expose collision/path mismatch.
- Remove visited-target check in AttackService; T06 should fail.
- Change pause processing mode to ALWAYS on world; T22/T30 should fail.

Use test_arena and docs/REPRODUCE_WORKFLOWS.md for controlled demonstrations. Do not present hypothetical failures as reproduced production incidents.

## Actual exit cleanup and completed save

Verbose graphical capture exposed an active AudioStreamWAV/playback retained on immediate process exit. AudioManager now explicitly stops and detaches active streams; quit waits briefly for audio processing. Repeated actual capture exits without the leak warning.

Final handoff audit found that only intermediate level completion wrote results. Finale now persists a validated finished flag and all three results; Continue returns to final results without spawning actors or appending duplicate results. T35 exercises actual final scene transition, disk write and Continue reload.
