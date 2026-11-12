extends SceneTree

var passed: int = 0
var failed: int = 0
var level
var saves: Node
var game: Node

func _initialize() -> void:
	call_deferred("run")
	create_timer(30.0).timeout.connect(func(): push_error("Test watchdog timeout"); quit(99))

func check(condition: bool, label: String) -> void:
	if condition:
		passed += 1
		print("PASS " + label)
	else:
		failed += 1
		push_error("FAIL " + label)

func frames(count: int = 3) -> void:
	for i in range(count):
		await physics_frame

func load_level(index: int) -> void:
	if is_instance_valid(level):
		level.queue_free()
		await frames()
	game.pending_save.clear()
	game.results.clear()
	level = load("res://scenes/levels/" + ["level_01_access", "level_02_vault", "level_03_escape", "test_arena"][index] + ".tscn").instantiate()
	root.add_child(level)
	await frames(5)
	level.player.health.immunity = 0.0
	for enemy in get_nodes_in_group("enemies"):
		enemy.set_physics_process(false)

func item(id: String):
	for object in level.objects:
		if object.item_id == id:
			return object
	return null

func approach(object) -> void:
	level.player.position = object.position + Vector2(-24, 0)
	await frames()

func run() -> void:
	saves = root.get_node("SaveManager")
	game = root.get_node("GameManager")
	# Tests never touch production saves, even if a test process crashes.
	saves.storage_path = "user://test-session-save.json"
	await load_level(0)
	var player = level.player
	check(is_equal_approx(player.movement(Vector2(1,1),95).length(), player.movement(Vector2.RIGHT,95).length()), "T01 normalized diagonal")
	var stamina = load("res://scripts/components/stamina_component.gd").new()
	stamina.current = 0.1
	stamina.step(1.0, true)
	var depleted = stamina.current == 0.0
	stamina.step(0.3, false)
	var delayed = stamina.current == 0.0
	stamina.step(0.4, false)
	check(depleted and delayed and is_equal_approx(stamina.current, 1.8), "T02 stamina clamp and fractional recovery delay")
	stamina.free()
	check(player.stats.crouch_speed < player.stats.walk_speed and player.stats.walk_speed < player.stats.sprint_speed, "T03 stance speeds")
	var hp = load("res://scripts/components/health_component.gd").new()
	hp.invulnerability = 0.0
	var deaths = [0]
	hp.died.connect(func(): deaths[0] += 1)
	hp.apply_damage(-1)
	var ignored = hp.current == 100.0
	hp.apply_damage(500)
	hp.apply_damage(500)
	check(ignored and hp.current == 0.0 and deaths[0] == 1, "T04 negative damage and single death")
	hp.free()
	hp = load("res://scripts/components/health_component.gd").new()
	hp.apply_damage(15)
	hp.apply_damage(15)
	check(hp.current == 85.0, "T05 post-hit invulnerability")
	hp.free()
	var enemy = get_nodes_in_group("enemies")[0]
	level.combat.hit_targets.clear()
	var first_hit = level.combat.apply_once(enemy, 1.5)
	check(first_hit and not level.combat.apply_once(enemy, 1.5), "T06 one stun per swing")
	enemy.stun_time = 0
	enemy.transition("PATROL", "test reset")
	enemy.hear(enemy.position + Vector2(10,0), 100, "test")
	check(enemy.state == "INVESTIGATE", "T07 hearing investigates source")
	enemy.position = level.world.center(Vector2i(11,6))
	player.position = level.world.center(Vector2i(13,6))
	enemy.facing = Vector2.RIGHT
	await frames()
	check(not load("res://scripts/enemies/vision_sensor.gd").visible(enemy, player), "T08 actual TileMapLayer raycast blocks vision")
	check(not load("res://scripts/enemies/vision_sensor.gd").inside_fov(Vector2.ZERO, Vector2.RIGHT, Vector2(-30,0), 150,90), "T09 outside FOV")
	enemy.transition("CHASE", "test")
	enemy.update_sensing(1.6, false, player)
	var searched = enemy.state == "SEARCH"
	enemy.state_time = 6.1
	enemy.last_seen = enemy.position
	enemy._physics_process(0.016)
	var returned = enemy.state == "RETURN"
	enemy.position = enemy.target
	enemy._physics_process(0.016)
	check(searched and returned and enemy.state == "PATROL", "T10 chase/search/return/patrol")
	enemy.transition("ATTACK", "test")
	enemy.stun(0.05)
	enemy._physics_process(0.02)
	var stopped = enemy.velocity == Vector2.ZERO and enemy.state == "STUNNED" and not enemy.attack_fired
	enemy._physics_process(0.04)
	check(stopped and enemy.state == "SEARCH", "T11 stun cancels attack and expires")
	enemy.receive_alert(enemy.position, 999)
	var alerts_before = enemy.seen_alerts.size()
	enemy.receive_alert(enemy.position, 999)
	check(enemy.seen_alerts.size() == alerts_before, "T12 deduplicated alert ID")
	var card = item("blue_card")
	await approach(card)
	var collected = card.interact(player)
	check(collected and not card.interact(player) and player.inventory.keycards.count("blue") == 1, "T13 pickup identity idempotent")
	var door = item("north_door")
	await approach(door)
	player.inventory.keycards.clear()
	var rejected = not door.interact(player)
	player.inventory.keycards.append("blue")
	var opened = door.interact(player)
	await frames()
	check(rejected and opened and door.opened and not level.world.path_grid.is_point_solid(Vector2i(25,8)), "T14 keycard door physics/navigation update")
	var terminal = item("security_console")
	await approach(terminal)
	terminal.interact(player)
	player.position += Vector2(-100,0)
	await frames()
	check(terminal.hack_actor == null and terminal.hack_progress == 0.0 and not terminal.used, "T15 terminal cancels out of range")
	var mission = load("res://scripts/missions/mission_manager.gd").new()
	mission.definitions = [{"id":"a","requires":[]},{"id":"b","requires":["a"]}]
	check(not mission.complete("b") and mission.complete("a") and not mission.complete("a") and mission.complete("b"), "T16 objective dependencies and idempotence")
	mission.free()
	check(not level.extract() and not level.finished, "T17 extraction refuses incomplete mission")
	var data = level.snapshot(player.position)
	var test_path = "user://test_roundtrip.json"
	check(saves.write_save(data,test_path) and saves.read_save(test_path) == JSON.parse_string(JSON.stringify(data)), "T18 atomic save roundtrip")
	var bad = FileAccess.open(test_path,FileAccess.WRITE)
	bad.store_string("{broken")
	bad.close()
	var corrupt_ok: bool = saves.read_save(test_path,false).is_empty()
	data.version = 999
	check(corrupt_ok and not saves.valid(data) and FileAccess.get_file_as_string(test_path) == "{broken", "T19 corrupt/future save safely rejected and preserved")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(test_path))
	var routes_ok = true
	for index in range(3):
		await load_level(index)
		# Reachability uses actual AStarGrid2D; unlock every authored door for final route audit.
		for object in level.objects:
			if object.kind == "door":
				object.open_door()
		for object in level.objects:
			if object.kind != "door" and level.world.path(level.player.position, object.position).is_empty():
				routes_ok = false
				print("UNREACHABLE ",index," ",object.item_id)
	check(routes_ok, "T20 all three authored objective routes reachable")
	await load_level(0)
	await load_level(0)
	check(get_nodes_in_group("player").size() == 1 and get_nodes_in_group("enemies").size() == 3, "T21 scene reload frees actors and signal listeners")
	var elapsed_before = level.elapsed
	paused = true
	await process_frame
	await process_frame
	check(level.elapsed == elapsed_before and level.hud.process_mode == Node.PROCESS_MODE_ALWAYS, "T22 pause halts simulation and keeps UI active")
	paused = false
	player = level.player
	enemy = get_nodes_in_group("enemies")[0]
	enemy.position = player.position + Vector2(20,0)
	player.inventory.emp_charges = 1
	var emp_activated = level.combat.emp(player)
	check(emp_activated and player.inventory.emp_charges == 0 and enemy.state == "STUNNED" and not level.combat.emp(player), "T23 EMP one charge and valid targets")
	player.position = level.world.center(Vector2i(13,6))
	enemy.position = level.world.center(Vector2i(11,6))
	player.health.immunity = 0
	var old_health = player.health.current
	enemy.strike(player)
	var projectile = load("res://scripts/combat/enemy_projectile.gd").new()
	projectile.position = enemy.position
	projectile.direction = Vector2.RIGHT
	level.add_child(projectile)
	await frames(35)
	check(player.health.current == old_health and not is_instance_valid(projectile), "T24 wall blocks melee and projectile")
	await load_level(2)
	for obj in level.mission.definitions:
		level.mission.complete(obj.id)
	var once = level.extract()
	check(once and not level.extract(), "T25 finale result emitted once")
	# Cancel deferred scene switch: dispose level before processing deferred GameManager call.
	await frames(3)
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	if is_instance_valid(level):
		level.queue_free()
	await frames()
	await load_level(3)
	var demo_enemy = get_nodes_in_group("enemies")[1]
	demo_enemy.agent.target_position = demo_enemy.position + Vector2(100,0)
	await frames(5)
	var next = demo_enemy.agent.get_next_path_position()
	check(demo_enemy.use_navigation_agent and demo_enemy.agent.get_current_navigation_path().size() >= 2 and next.is_finite(), "T26 real NavigationAgent2D route in arena")
	check(not demo_enemy.transition("INVALID", "test"), "T27 invalid FSM request rejected")
	var camera = get_nodes_in_group("enemies")[3]
	camera.stun(0.05)
	camera._physics_process(0.06)
	check(camera.state != "STUNNED", "T28 disabled camera resumes")
	await load_level(0)
	player = level.player
	player.position = level.world.center(Vector2i(11,6))
	Input.action_press("move_right")
	await frames(40)
	Input.action_release("move_right")
	check(player.position.x <= 376.1 and player.position.x > 368, "T29 actual CharacterBody2D stops against TileMapLayer")
	card = item("blue_card")
	await approach(card)
	card.interact(player)
	terminal = item("security_console")
	await approach(terminal)
	terminal.interact(player)
	await frames(10)
	var progress = terminal.hack_progress
	paused = true
	for i in range(5):
		await process_frame
	var hack_paused = terminal.hack_progress == progress
	paused = false
	player.health.immunity = 0
	player.health.apply_damage(1)
	await frames(3)
	var hack_canceled = terminal.hack_actor == null and not terminal.used
	terminal.interact(player)
	await frames(185)
	check(hack_paused and hack_canceled and terminal.used and level.mission.completed.count("security") == 1, "T30 real hacking pauses, cancels on damage, completes after 3s")
	data = level.snapshot(player.position)
	var invalid_position = data.duplicate(true)
	invalid_position.position = [-1,10]
	var invalid_objective = data.duplicate(true)
	invalid_objective.objectives.append("forged_future_objective")
	var invalid_metrics = data.duplicate(true)
	invalid_metrics.metrics.damage = "bad"
	check(not saves.valid(invalid_position) and not saves.valid(invalid_objective) and not saves.valid(invalid_metrics), "T31 malformed coordinates, mission IDs and statistics rejected")
	item("north_door").open_door()
	player.inventory.emp_charges = 2
	player.health.current = 73
	data = level.snapshot(player.position)
	saves.write_save(data,"user://test-restoration.json")
	await load_level(0)
	level.restore(saves.read_save("user://test-restoration.json"))
	check(level.player.health.current == 73 and level.player.inventory.emp_charges == 2 and level.player.inventory.keycards.count("blue") == 1 and item("blue_card").used and item("north_door").opened and level.mission.all_complete(), "T32 scene save restore preserves inventory, doors, pickups and objectives")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test-restoration.json"))
	var menus_ok = true
	for path in ["main_menu", "settings_menu", "credits", "results"]:
		var menu = load("res://scenes/menus/%s.tscn" % path).instantiate()
		root.add_child(menu)
		await process_frame
		menus_ok = menus_ok and menu.content.get_child_count() >= 4
		menu.queue_free()
		await process_frame
	check(menus_ok, "T33 main/settings/credits/results scenes instantiate")
	var noises = [0]
	var listener = func(_at, _radius, kind):
		if kind == "sprint":
			noises[0] += 1
	root.get_node("EventBus").noise_emitted.connect(listener)
	Input.action_press("move_down")
	Input.action_press("sprint")
	await frames(80)
	var sprint_noises = noises[0]
	Input.action_press("crouch")
	await frames(40)
	Input.action_release("move_down")
	Input.action_release("sprint")
	Input.action_release("crouch")
	root.get_node("EventBus").noise_emitted.disconnect(listener)
	check(sprint_noises > 0 and sprint_noises <= 3 and noises[0] == sprint_noises, "T34 sprint noise throttled, crouch silent")
	level.queue_free()
	await frames()
	game.results.clear()
	for index in range(2):
		game.results.append({"level":index,"title":"Test sector","time":10.0,"grade":"GOLD","undetected":true,"metrics":{"detections":0,"damage":0,"alerts":0,"emp":0,"stuns":0}})
	game.level_index = 2
	game.pending_save.clear()
	game.start_level()
	await scene_changed
	level = current_scene
	level.mission.complete("power")
	level.mission.complete("override")
	level.extract()
	await scene_changed
	var completed_save = saves.read_save()
	var final_saved = completed_save.get("finished",false) and completed_save.get("results",[]).size() == 3
	game.continue_game()
	await scene_changed
	check(final_saved and current_scene.screen == "results" and game.last_result.level == 2 and get_nodes_in_group("player").is_empty(), "T35 completed campaign persists and Continue restores final results")
	current_scene.queue_free()
	await frames()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(saves.storage_path))
	print("RESULT: %d passed, %d failed" % [passed,failed])
	quit(0 if failed == 0 else 1)
