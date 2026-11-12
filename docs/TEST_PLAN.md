# Testing and release QA

Run from project root with Godot 4.7.2:

```sh
GODOT=/path/to/Godot tools/validate_project.sh
```

The shell gate checks process exits and engine error logs. `tests/run_tests.gd` uses explicit checks, counts pass/fail, exits nonzero on failure, and has a watchdog. Gameplay classes are loaded after autoload initialization for --script compatibility. Unit tests use isolated save paths and cannot overwrite mission saves even if they crash.

| Cases | Coverage / execution mode |
|---|---|
| T01–T05 | movement math, fractional stamina timing, stance tuning, health/death, immunity |
| T06–T12 | swing dedupe, hearing, actual wall raycast, FOV, state chain, stun, alert dedupe |
| T13–T19 | actual pickups/doors/hacking cancel, dependency graph, extraction gate, disk save/corruption |
| T20–T25 | three-map reachability, reload actor count, pause, EMP, swept projectile wall, finale idempotence |
| T26–T28 | real NavigationAgent2D path, invalid FSM requests, camera re-enable |
| T29–T35 | physical player wall collision, timed hacking/pause/damage, malformed saves, full scene restore, menus, sprint/crouch hearing, completed-save Continue |
| Python checks | unsafe ZIP paths/symlinks, safe extraction, mapping traversal, PNG dimensions |
| Input-driven playthrough | actual New Game → levels 1/2/3 → final results; all AI active |

`tests/playthrough.gd` uses accelerated physics time, no developer invulnerability, and isolated saves. Its combat helper uses the same AttackService as normal input. Individual focused integration tests reposition actors deliberately to construct test conditions; those are not claimed as full-level playthroughs.

## Manual review performed

Native window inspected through desktop UI: menu, New Operation, sustained W movement, F3 telemetry, Escape pause. HUD clipping and hidden menu background were found and fixed. Real engine viewport screenshots captured separately. Exported macOS game subsequently completed all three levels through actual native keyboard input at normal time. Observed Gold L1 (23.3s), Bronze L2 (81.2s after checkpoint retry), Silver L3 (46.7s), total displayed 151.3s. Game Over, R retry, data checkpoint, cameras/EMP, Lockdown, final countdown and Mission Complete were observed. This was an agent-operated known route with pauses; it is not a blind human duration study.

## Remaining human review

1. Conduct a blind human balance/readability review; the agent-operated route is already complete.
2. Let guards detect, break LOS, observe Search/Return, and test EMP cameras resume after five seconds.
3. Die, press R, retry; quit/relaunch and Continue at checkpoint. Check no duplicate items or actors.
4. Change fullscreen/audio/shake, relaunch, resize and alt-tab. Verify keyboard focus and audio on target hardware.
5. Test actual exports on Windows/Linux and Gatekeeper/notarization flow for public macOS distribution.

See IMPLEMENTATION_STATUS.md for acceptance matrix and actual current counts. CI configuration exists but no hosted run or green badge is claimed.
