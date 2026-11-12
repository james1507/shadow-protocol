# Gameplay systems

- Movement: normalized 8-way, walk 95 / sprint 145 / crouch 58 px/s. Sprint drains 24/s, recovery 18/s after 0.6s; exhaustion locks sprint until 10 stamina. Crouch emits no sprint noise. Sprint hearing events at most once per 0.6s.
- Health: 100 max, 0.6s hit immunity, single death, medkit +30, no negative damage/heal. Spawn grants two seconds to avoid unavoidable checkpoint detection.
- Interaction: nearest eligible target within 40px, deterministic authored ordering for ties, solid-world raycast. E is edge-triggered. Item IDs prevent duplicate pickup rewards.
- Baton: click, 0.15s wind-up, 43px range, facing cone, 0.55s cooldown, 1.5s nonlethal stun; one effect per target per swing. Actual hit requires clear world LOS.
- EMP: Q, 110px pulse, charge cap 3. Camera/drone 5s disable, guard 2s stun, heavy 1s. A pulse traverses walls as an electromagnetic gadget; visual/melee/projectiles do not.
- Guard: 150px / 90° FOV; heavy 165px / 100°; drone 190px / 110°. Crouch reduces range to 70% and accumulation to 65%; sprint accumulates 1.4x. Confirmation normally takes 0.9s. Cameras sweep a bounded arc.
- FSM: PATROL, SUSPICIOUS, INVESTIGATE, CHASE, ATTACK, SEARCH, STUNNED, RETURN. Lost sight 1.5s, search 6s. Stun cancels attack. Attack wind-up 0.4s, cooldown 1.25s. Guard damage 15, drone pulse 10. Nearby alerts reach 220px and deduplicate IDs.
- Alarm: CALM, SUSPICIOUS (>5), ALERT (>=50), LOCKDOWN (>=85). Confirmed alerts add 35, hidden decay begins after five seconds at 5/s. Terminal reduces alarm 45. Lockdown increases visible security pressure; it never seals a mandatory route.
- Scoring: GOLD requires zero detections and zero damage. SILVER allows <=3 detections and <=45 damage. Otherwise BRONZE. Time, alerts, EMP and stuns are shown as separate factual statistics.
- Missions: linear dependency graphs, idempotent completion, early extraction reports next missing objective. Level 3 starts a 90-second escape timer after override, with checkpoint retry resetting the timer.
- Checkpoints: initial spawn, explicit C markers, level 1 security terminal, level 2 data chip, level 3 override. Save preserves health/stamina/inventory/objectives/items/doors/results; enemies reset on retry. Completing a mission writes a fresh next-mission save; finale persists all three results and Continue reopens completed-run results.
- Audio: original synthesized PCM tones for footsteps, interaction, hit, EMP, stun, alarm and success. Master/SFX/Music buses. No music loop supplied; Music slider is reserved for future licensed music. Missing sound keys safely return; one-shots rate limited and freed.
- UI: keyboard-focusable native menus, pause/game over/settings/results, health/stamina, inventory, objective bearing and minimap. F3 shows live state; PageUp/PageDown browse bounded event history. F4 only in debug arena cycles 10/20/40/3 agents.

Visuals use original palette and geometry. Animation is procedural bobbing, facing, flashing, sliding doors, hack progress, rotating drone/camera parts and EMP pulses; player baton flash uses a real AnimationPlayer track.
