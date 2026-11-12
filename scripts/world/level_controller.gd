class_name LevelController
extends Node2D

@export var level_id: int = 0
var definition: Dictionary
var world: GridWorld
var player: PlayerController
var mission: MissionManager
var hud: GameHUD
var combat: AttackService
var objects: Array[WorldItem] = []
var picked_ids: Dictionary = {}
var opened_ids: Dictionary = {}
var checkpoint_data: Dictionary = {}
var elapsed: float = 0.0
var alarm_value: float = 0.0
var alarm_quiet: float = 0.0
var countdown: float = 90.0
var finished: bool = false
var metrics: Dictionary = {"detections": 0, "damage": 0.0, "alerts": 0, "emp": 0, "stuns": 0}
var noises: Array[Dictionary] = []
var enemy_root: Node2D
var debug_offset: int = 0

func _ready() -> void:
	var path := "res://data/missions/level_0%d.json" % (level_id + 1) if level_id < 3 else "res://data/missions/test_arena.json"
	definition = JSON.parse_string(FileAccess.get_file_as_string(path))
	if level_id < 3:
		GameManager.level_index = level_id
	world = GridWorld.new()
	world.name = "World"
	add_child(world)
	world.build(definition)
	mission = MissionManager.new()
	mission.name = "MissionManager"
	mission.definitions = definition.objectives
	add_child(mission)
	var interactables := Node2D.new()
	interactables.name = "Interactables"
	add_child(interactables)
	for entry in definition.objects:
		var scene_name: String = {"health": "health_pickup", "emp": "emp_pickup", "chip": "data_chip", "extraction": "extraction_zone"}.get(entry.kind, entry.kind)
		var item: WorldItem = load("res://scenes/interactables/%s.tscn" % scene_name).instantiate()
		item.name = entry.id
		item.item_id = entry.id
		item.key = entry.key
		item.objective = entry.objective
		item.position = world.center(Vector2i(entry.cell[0], entry.cell[1]))
		item.level = self
		interactables.add_child(item)
		objects.append(item)
	player = preload("res://scenes/player/player.tscn").instantiate()
	player.position = world.center(Vector2i(definition.spawn[0], definition.spawn[1]))
	player.level = self
	add_child(player)
	player.health.died.connect(func(): hud.show_death())
	player.health.health_changed.connect(on_health_changed)
	player.health.immunity = 2.0
	var camera: Camera2D = player.get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = world.grid_size.x * 32
	camera.limit_bottom = world.grid_size.y * 32
	combat = AttackService.new()
	combat.level = self
	add_child(combat)
	enemy_root = Node2D.new()
	enemy_root.name = "Enemies"
	add_child(enemy_root)
	if level_id == 3:
		var region := NavigationRegion2D.new()
		region.name = "NavigationAgentDemoRegion"
		var polygon := NavigationPolygon.new()
		polygon.vertices = PackedVector2Array([Vector2(480,64), Vector2(896,64), Vector2(896,640), Vector2(480,640)])
		polygon.add_polygon(PackedInt32Array([0,1,2,3]))
		region.navigation_polygon = polygon
		add_child(region)
	if ResourceLoader.exists("res://scenes/enemies/guard.tscn"):
		spawn_enemies()
	if not GameManager.pending_save.is_empty() and level_id < 3:
		restore(GameManager.pending_save)
		GameManager.pending_save.clear()
	checkpoint_data = snapshot(player.position)
	if level_id < 3:
		SaveManager.write_save(checkpoint_data)
	hud = GameHUD.new()
	hud.name = "GameHUD"
	hud.level = self
	add_child(hud)
	EventBus.noise_emitted.connect(on_noise)
	EventBus.alert_raised.connect(on_alert)
	EventBus.objective_completed.connect(func(_id: String): AudioManager.play_sfx("success"))

func spawn_enemies() -> void:
	for entry in definition.guards:
		var enemy = load("res://scenes/enemies/%s.tscn" % entry.kind).instantiate()
		enemy.level = self
		enemy.position = world.center(Vector2i(entry.cell[0], entry.cell[1]))
		enemy.use_navigation_agent = level_id == 3 and entry.kind == "heavy"
		for cell in entry.patrol:
			enemy.patrol.append(world.center(Vector2i(cell[0], cell[1])))
		enemy_root.add_child(enemy)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player) or finished:
		return
	elapsed += delta
	alarm_quiet += delta
	if alarm_quiet > 5.0:
		alarm_value = maxf(0.0, alarm_value - delta * 5.0)
	if level_id == 2 and "override" in mission.completed:
		countdown -= delta
		if countdown <= 0.0 and not player.health.dead:
			player.health.die()
	for noise in noises:
		noise.time -= delta
	noises = noises.filter(func(noise: Dictionary): return noise.time > 0.0)
	if SettingsManager.values.shake:
		var camera: Camera2D = player.get_node("Camera2D")
		camera.offset = Vector2(sin(elapsed * 75), cos(elapsed * 83)) * 2.0 if player.health.immunity > 0.35 and player.health.immunity < 0.6 else Vector2.ZERO
	queue_redraw()

func player_actions(actor: PlayerController) -> void:
	if Input.is_action_just_pressed("interact"):
		var target := nearest_interactable()
		if is_instance_valid(target):
			target.interact(actor)
	if Input.is_action_just_pressed("attack"):
		combat.attack(actor)
	if Input.is_action_just_pressed("gadget"):
		combat.emp(actor)

func nearest_interactable() -> WorldItem:
	var nearest: WorldItem = null
	var distance: float = player.stats.interaction_range + 0.01
	for item in objects:
		if not item.can_interact(player):
			continue
		var d := player.global_position.distance_to(item.global_position)
		if d < distance and interaction_los(player, item):
			distance = d
			nearest = item
	return nearest

func interaction_los(actor: PlayerController, item: WorldItem) -> bool:
	var query := PhysicsRayQueryParameters2D.create(actor.global_position, item.global_position, 1)
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.collider == item.door_body

func clear_los(from: Vector2, to: Vector2) -> bool:
	var query := PhysicsRayQueryParameters2D.create(from, to, 1)
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func terminal_completed(item: WorldItem) -> void:
	EventBus.notification.emit("System overridden · " + mission.next_title())
	alarm_value = maxf(0.0, alarm_value - 45.0)
	for object in objects:
		if object.kind == "door" and object.key == item.objective:
			object.open_door()
	if item.objective in ["security", "override"]:
		checkpoint(item.position + Vector2(-24, 0))
	if item.objective == "override":
		countdown = 90.0

func checkpoint(at: Vector2) -> void:
	if level_id == 3 or player.health.dead:
		EventBus.notification.emit("Arena isolated · mission save untouched")
		return
	checkpoint_data = snapshot(at)
	if SaveManager.write_save(checkpoint_data):
		EventBus.notification.emit("Checkpoint saved · " + mission.next_title())
	else:
		EventBus.notification.emit(SaveManager.last_error)

func snapshot(at: Vector2) -> Dictionary:
	return {"version": 1, "level": mini(level_id, 2), "checkpoint": "field", "position": [at.x, at.y], "health": player.health.current, "stamina": player.stamina.current, "inventory": player.inventory.duplicate(true), "objectives": mission.completed.duplicate(), "pickups": picked_ids.keys(), "doors": opened_ids.keys(), "results": GameManager.results.duplicate(true), "elapsed": elapsed, "metrics": metrics.duplicate(true), "options": SettingsManager.values.duplicate()}

func restore(data: Dictionary) -> void:
	if not SaveManager.valid(data) or int(data.level) != level_id:
		EventBus.notification.emit("Invalid checkpoint; safe starting state retained")
		return
	# Validate against this authored map as well as the schema. Reject forged wall spawns.
	var at := Vector2(data.position[0], data.position[1])
	var cell := Vector2i(at / 32)
	if not world.path_grid.is_in_boundsv(cell) or world.path_grid.is_point_solid(cell):
		EventBus.notification.emit("Invalid checkpoint position; safe spawn used")
	else:
		player.position = at
	player.health.current = data.health
	set_meta("previous_health", player.health.current)
	player.stamina.current = data.stamina
	player.inventory = data.inventory.duplicate(true)
	mission.completed = data.objectives.filter(func(id: String): return definition.objectives.any(func(o: Dictionary): return o.id == id))
	GameManager.results = data.results.duplicate(true)
	elapsed = float(data.get("elapsed", 0.0))
	var saved_metrics: Variant = data.get("metrics", {})
	if saved_metrics is Dictionary:
		for key in metrics:
			if saved_metrics.get(key) is float or saved_metrics.get(key) is int:
				metrics[key] = maxf(0.0, saved_metrics[key])
	for item in objects:
		if item.item_id in data.pickups:
			if item.kind == "terminal":
				item.used = true
				picked_ids[item.item_id] = true
			else:
				item.consume()
		if item.kind == "door" and item.item_id in data.doors:
			item.open_door()
	countdown = 90.0

func retry() -> void:
	if level_id == 3:
		get_tree().paused = false
		get_tree().reload_current_scene()
		return
	GameManager.pending_save = checkpoint_data.duplicate(true)
	GameManager.start_level()

func extract() -> bool:
	if finished or player.health.dead:
		return false
	if not mission.all_complete():
		EventBus.notification.emit("Extraction locked · " + mission.next_title())
		return false
	finished = true
	var grade: String = "GOLD" if metrics.detections == 0 and metrics.damage == 0 else ("SILVER" if metrics.detections <= 3 and metrics.damage <= 45 else "BRONZE")
	var result := {"level": level_id, "title": definition.title, "time": elapsed, "grade": grade, "metrics": metrics.duplicate(), "undetected": metrics.detections == 0}
	AudioManager.play_sfx("success")
	GameManager.call_deferred("finish_level", result)
	return true

func on_health_changed(current: float, _maximum: float) -> void:
	var previous: float = float(get_meta("previous_health", 100.0))
	if current < previous:
		metrics.damage += previous - current
		AudioManager.play_sfx("hit")
	set_meta("previous_health", current)

func on_noise(at: Vector2, radius: float, kind: String) -> void:
	noises.append({"at": at, "radius": radius, "kind": kind, "time": 0.6})

func on_alert(_at: Vector2, _id: int) -> void:
	alarm_value = minf(100.0, alarm_value + 35.0)
	alarm_quiet = 0.0
	metrics.alerts += 1
	AudioManager.play_sfx("alarm")

func alarm_name() -> String:
	var status := "CALM"
	if alarm_value >= 85:
		status = "LOCKDOWN"
	elif alarm_value >= 50:
		status = "ALERT"
	elif alarm_value > 5:
		status = "SUSPICIOUS"
	if level_id == 2 and "override" in mission.completed:
		status += " / %02d:%02d" % [int(countdown) / 60, int(countdown) % 60]
	return status

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("developer_overlay") and OS.is_debug_build():
		GameManager.debug_enabled = not GameManager.debug_enabled
		if GameManager.debug_enabled:
			EventBus.dump_events()
	if event is InputEventKey and event.pressed and OS.is_debug_build() and GameManager.debug_enabled:
		if event.keycode == KEY_PAGEUP:
			debug_offset = mini(45, debug_offset + 5)
		elif event.keycode == KEY_PAGEDOWN:
			debug_offset = maxi(0, debug_offset - 5)
	if event is InputEventKey and event.pressed and event.keycode == KEY_F4 and level_id == 3 and OS.is_debug_build():
		stress_agents()

func stress_agents() -> void:
	var count := enemy_root.get_child_count()
	var target := 10 if count < 10 else (20 if count < 20 else (40 if count < 40 else 3))
	for enemy in enemy_root.get_children():
		enemy.queue_free()
	for i in range(target):
		var enemy = load("res://scenes/enemies/guard.tscn").instantiate()
		enemy.level = self
		enemy.position = world.center(Vector2i(16 + i % 10, 3 + i / 10 * 3))
		enemy.patrol.append(enemy.position)
		enemy.patrol.append(enemy.position + Vector2(0, 64))
		enemy_root.add_child(enemy)
	print("STRESS agents=%d resolution=1280x720 debug=%s" % [target, GameManager.debug_enabled])

func debug_summary() -> String:
	var states: Dictionary = {}
	var nearest = null
	var distance := INF
	for enemy in get_tree().get_nodes_in_group("enemies"):
		states[enemy.state] = states.get(enemy.state, 0) + 1
		var d: float = enemy.position.distance_to(player.position)
		if d < distance:
			distance = d
			nearest = enemy
	var text := "F3 / LIVE TELEMETRY\nFPS %d  PHYSICS %d  LEVEL %d\nPOS %s  VEL %s\n%s\nPROJECTILES %d  PICKUPS %d\n" % [Engine.get_frames_per_second(), Engine.get_physics_frames(), level_id + 1, player.position.round(), player.velocity.round(), str(states), get_tree().get_nodes_in_group("projectiles").size(), picked_ids.size()]
	if is_instance_valid(nearest):
		text += "%s %.2f  PATH %d\nLAST SEEN %s\n" % [nearest.state, nearest.detection, nearest.route.size(), nearest.last_seen.round()]
	var first: int = maxi(0, EventBus.events.size() - 5 - debug_offset)
	for i in range(first, mini(first + 5, EventBus.events.size())):
		var entry: Dictionary = EventBus.events[i]
		text += "%d %s > %s (%s)\n" % [entry.time, entry.from, entry.to, entry.reason]
	text += "PgUp/PgDn / event history"
	return text

func _draw() -> void:
	if not GameManager.debug_enabled or not OS.is_debug_build():
		return
	for noise in noises:
		draw_arc(noise.at, noise.radius, 0, TAU, 48, Color(0.26,0.85,0.9,0.3), 1)
	for item in objects:
		if item.kind == "door":
			draw_rect(Rect2(item.position - Vector2(16,16), Vector2(32,64)), Color.GREEN if item.opened else Color.RED, false, 1)
