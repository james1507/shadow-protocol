extends SceneTree

var level
var game
var saves
var failures: int = 0
var total_frames: int = 0
var last_scene

func _initialize() -> void:
	call_deferred("run")
	create_timer(180.0, true, false, true).timeout.connect(func(): push_error("Playthrough watchdog"); quit(99))

func tick(count: int = 1) -> void:
	for i in range(count):
		await physics_frame
		total_frames += 1

func release() -> void:
	for action in ["move_left", "move_right", "move_up", "move_down", "interact", "crouch", "attack", "gadget"]:
		Input.action_release(action)

func press(action: String) -> void:
	Input.action_press(action)
	await tick(2)
	Input.action_release(action)
	await tick(2)

func walk(to: Vector2) -> bool:
	var route = level.world.path(level.player.position, to)
	if route.is_empty():
		print("NO ROUTE ", level.player.position," to ",to)
		return false
	Input.action_press("crouch")
	for index in range(1,route.size()):
		var point = route[index]
		var iterations = 0
		while level.player.position.distance_to(point) > 5.0:
			if level.player.health.dead:
				print("BOT DOWN ",level.player.position)
				return false
			var offset = point - level.player.position
			for action in ["move_left", "move_right", "move_up", "move_down"]:
				Input.action_release(action)
			if absf(offset.x) > 2.0:
				Input.action_press("move_right" if offset.x > 0 else "move_left")
			if absf(offset.y) > 2.0:
				Input.action_press("move_down" if offset.y > 0 else "move_up")
			# Combat uses the same public attack/EMP actions as player input; no immunity cheats.
			for enemy in get_nodes_in_group("enemies"):
				if enemy.position.distance_to(level.player.position) < 38.0 and enemy.state != "STUNNED":
					level.player.facing = (enemy.position - level.player.position).normalized()
					level.combat.attack(level.player)
				if enemy.state in ["CHASE","ATTACK"] and enemy.position.distance_to(level.player.position) < 100 and level.player.inventory.emp_charges > 0:
					await press("gadget")
			await tick()
			iterations += 1
			if iterations > 240:
				print("STUCK ",level.player.position," target ",point)
				return false
		for action in ["move_left", "move_right", "move_up", "move_down"]:
			Input.action_release(action)
	release()
	return true

func interact_with(id: String) -> bool:
	var target = null
	for item in level.objects:
		if item.item_id == id:
			target = item
	if target == null:
		return false
	# Approach nearest reachable adjacent cell, never teleport or modify objective state.
	var nearest_route = PackedVector2Array()
	var destination = target.position
	for offset in [Vector2(-32,0), Vector2(32,0), Vector2(0,-32), Vector2(0,32)]:
		var candidate = target.position + offset
		var route = level.world.path(level.player.position,candidate)
		if not route.is_empty() and (nearest_route.is_empty() or route.size() < nearest_route.size()):
			nearest_route = route
			destination = candidate
	if not await walk(destination):
		return false
	var target_kind = target.kind
	var before_health = level.player.health.current
	var before_position = level.player.position
	if target_kind == "terminal":
		# Use EMP to hold a clear hacking window; retry if an enemy interrupts it.
		for attempt in range(4):
			if level.player.inventory.emp_charges > 0:
				await press("gadget")
			await press("interact")
			await tick(int(ceil(180.0 / Engine.time_scale)) + 6)
			if target.used:
				break
		if not target.used:
			print("HACK FAILED ",id," hp=",level.player.health.current)
			return false
	else:
		await press("interact")
	print("BOT INTERACT ",id," hp=",before_health," pos=",before_position)
	return true

func run() -> void:
	game = root.get_node("GameManager")
	saves = root.get_node("SaveManager")
	saves.storage_path = "user://bot-playthrough-save.json"
	Engine.max_fps = 0
	# Deterministic physics remains 60 Hz; time_scale speeds the native simulation.
	Engine.time_scale = 4.0
	game.new_game()
	await scene_changed
	await tick(6)
	var routes = [
		["blue_card","security_console","north_door","exit01"],
		["red_card","lab_door","vault_console","data_chip","emp02","escape_console","exit02"],
		["power_console","emp03","override_console","exit03"]]
	for index in range(3):
		level = current_scene
		for id in routes[index]:
			if not await interact_with(id):
				failures += 1
				break
		if failures > 0:
			break
		await process_frame
		await process_frame
		if current_scene == level or game.last_result.get("level",-1) != index:
			print("NO RESULTS SCREEN ",index)
			failures += 1
			break
		print("PLAYTHROUGH LEVEL ",index+1," PASS ",game.last_result)
		if index < 2:
			game.level_index += 1
			game.pending_save = saves.read_save()
			game.start_level()
			await scene_changed
			await tick(6)
	release()
	print("PLAYTHROUGH RESULT: ",3 if failures == 0 else game.level_index," levels completed, ",failures," failures; physics frames=",total_frames)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(saves.storage_path))
	quit(0 if failures == 0 else 1)
