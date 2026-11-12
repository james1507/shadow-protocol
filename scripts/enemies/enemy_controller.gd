class_name EnemyController
extends CharacterBody2D

const STATES := ["PATROL", "SUSPICIOUS", "INVESTIGATE", "CHASE", "ATTACK", "SEARCH", "STUNNED", "RETURN"]
@export_enum("guard", "heavy", "drone", "camera") var kind: String = "guard"
@export var config: EnemyConfig = preload("res://config/balance/guard.tres")
@onready var agent: NavigationAgent2D = $NavigationAgent2D
var level: Node2D
var patrol: Array[Vector2] = []
var patrol_index: int = 0
var state: String = "PATROL"
var state_time: float = 0.0
var detection: float = 0.0
var facing: Vector2 = Vector2.DOWN
var last_seen: Vector2 = Vector2.ZERO
var target: Vector2 = Vector2.ZERO
var lost_time: float = 0.0
var stun_time: float = 0.0
var attack_clock: float = 0.0
var attack_fired: bool = false
var route := PackedVector2Array()
var route_index: int = 0
var repath: float = 0.0
var seen_alerts: Dictionary = {}
var alert_cooldown: float = 0.0
var clock: float = 0.0
var use_navigation_agent: bool = false
var stuck_time: float = 0.0
var previous_position: Vector2
var recovery_attempted: bool = false
var visual: CharacterVisual

func _ready() -> void:
	add_to_group("enemies")
	if patrol.is_empty():
		patrol.append(position)
	target = patrol[0]
	last_seen = position
	previous_position = position
	visual = get_node_or_null("CharacterVisual")
	if visual != null:
		visual.set_profile(CharacterVisualRegistry.resolve(visual.actor_key))
	EventBus.noise_emitted.connect(hear)
	EventBus.alert_raised.connect(receive_alert)

func transition(next: String, reason: String) -> bool:
	if next not in STATES or next == state or (state == "STUNNED" and stun_time > 0.0 and next != "STUNNED"):
		return false
	EventBus.record(str(name), state, next, reason)
	if next == "ATTACK" and visual != null:
		visual.play_attack()
	state = next
	state_time = 0.0
	attack_clock = 0.0
	attack_fired = false
	repath = 0.0
	if next == "RETURN":
		var nearest := INF
		for i in range(patrol.size()):
			if position.distance_to(patrol[i]) < nearest:
				nearest = position.distance_to(patrol[i])
				patrol_index = i
		target = patrol[patrol_index]
	return true

func hear(at: Vector2, radius: float, _type: String) -> void:
	if kind == "camera" or state in ["CHASE", "ATTACK", "STUNNED"]:
		return
	if position.distance_to(at) <= radius * config.hearing_multiplier:
		target = at
		last_seen = at
		transition("INVESTIGATE", "noise")

func receive_alert(at: Vector2, id: int) -> void:
	if seen_alerts.has(id):
		return
	seen_alerts[id] = true
	if seen_alerts.size() > 50:
		seen_alerts.erase(seen_alerts.keys()[0])
	if kind != "camera" and position.distance_to(at) <= 220.0 and state not in ["CHASE", "ATTACK", "STUNNED"]:
		target = at
		last_seen = at
		transition("INVESTIGATE", "nearby alert")

func stun(seconds: float) -> void:
	stun_time = maxf(stun_time, seconds)
	transition("STUNNED", "EMP or baton")
	velocity = Vector2.ZERO
	attack_clock = 0.0
	attack_fired = false
	if visual != null:
		visual.set_status(&"stunned", true)

func _physics_process(delta: float) -> void:
	clock += delta
	state_time += delta
	alert_cooldown = maxf(0.0, alert_cooldown - delta)
	velocity = Vector2.ZERO
	if state == "STUNNED":
		stun_time = maxf(0.0, stun_time - delta)
		if stun_time <= 0.0:
			detection = 0.0
			transition("SEARCH", "stun expired")
		update_visual()
		queue_redraw()
		return
	if not is_instance_valid(level.player):
		return
	var player: PlayerController = level.player
	if kind == "camera":
		facing = Vector2.from_angle(PI * 0.65 + sin(clock * 0.65) * 0.85)
	var can_see: bool = VisionSensor.visible(self, player)
	update_sensing(delta, can_see, player)
	if kind == "camera":
		queue_redraw()
		return
	match state:
		"PATROL":
			target = patrol[patrol_index]
			if position.distance_to(target) < 7.0:
				patrol_index = (patrol_index + 1) % patrol.size()
				target = patrol[patrol_index]
			move_toward_target(delta, 1.0)
		"SUSPICIOUS":
			facing = facing.rotated(delta * 0.25)
		"INVESTIGATE":
			move_toward_target(delta, 1.1)
			if position.distance_to(target) < 12.0 or state_time > 10.0:
				transition("SEARCH", "investigation arrival")
		"CHASE":
			target = last_seen
			move_toward_target(delta, 1.45)
			if can_see and position.distance_to(player.position) <= config.attack_range:
				transition("ATTACK", "target in range")
		"ATTACK":
			facing = (player.position - position).normalized()
			if not can_see or position.distance_to(player.position) > config.attack_range + 8.0:
				transition("CHASE" if can_see else "SEARCH", "target moved")
			else:
				attack_clock += delta
				if attack_clock >= config.windup and not attack_fired:
					attack_fired = true
					strike(player)
				if attack_clock >= config.windup + config.attack_cooldown:
					attack_clock = 0.0
					attack_fired = false
					if visual != null: visual.play_attack()
		"SEARCH":
			target = last_seen
			if position.distance_to(target) > 15.0:
				move_toward_target(delta, 0.85)
			else:
				facing = facing.rotated(delta * 1.8)
			if state_time >= config.search_seconds:
				transition("RETURN", "search timeout")
		"RETURN":
			move_toward_target(delta, 1.0)
			if position.distance_to(target) < 10.0:
				transition("PATROL", "route restored")
	move_and_slide()
	if velocity.length() > 5.0 and position.distance_to(previous_position) < 0.1:
		stuck_time += delta
		if stuck_time > 2.0 and not recovery_attempted:
			repath = 0.0
			recovery_attempted = true
			if state not in ["CHASE", "ATTACK"]:
				transition("RETURN", "blocked route recovery")
	else:
		stuck_time = 0.0
		recovery_attempted = false
	previous_position = position
	update_visual()
	queue_redraw()

func update_sensing(delta: float, can_see: bool, player: PlayerController) -> void:
	if can_see:
		last_seen = player.position
		lost_time = 0.0
		detection = minf(1.0, detection + delta / config.detection_seconds * (1.4 if player.sprinting else (0.65 if player.crouching else 1.0)))
		if detection >= 1.0 and state not in ["CHASE", "ATTACK"]:
			transition("CHASE", "confirmed visual")
			level.metrics.detections += 1
			if alert_cooldown <= 0.0:
				alert_cooldown = 5.0
				EventBus.raise_alert(position)
		elif detection > 0.05 and state == "PATROL":
			level.alarm_value = maxf(level.alarm_value, 15.0)
			level.alarm_quiet = 0.0
			transition("SUSPICIOUS", "partial visual")
	else:
		lost_time += delta
		detection = maxf(0.0, detection - delta * 0.45)
		if state in ["CHASE", "ATTACK"] and lost_time >= config.lost_sight_seconds:
			transition("SEARCH", "lost sight")
		elif state == "SUSPICIOUS" and detection <= 0.0:
			transition("PATROL", "suspicion cleared")

func move_toward_target(delta: float, multiplier: float) -> void:
	repath -= delta
	if repath <= 0.0:
		repath = config.repath_seconds
		if use_navigation_agent:
			agent.target_position = target
		else:
			route = level.world.path(position, target)
			route_index = 1 if route.size() > 1 else 0
	var next := position
	if use_navigation_agent:
		if NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
			return
		next = agent.get_next_path_position()
		route = agent.get_current_navigation_path()
	elif route_index < route.size():
		next = route[route_index]
		if position.distance_to(next) < 5.0:
			route_index += 1
	if position.distance_to(target) > 5.0 and position.distance_to(next) > 1.0:
		velocity = (next - position).normalized() * config.speed * multiplier
		facing = velocity.normalized()

func strike(player: PlayerController) -> void:
	if player.health.dead or position.distance_to(player.position) > config.attack_range + 1.0 or not level.clear_los(position, player.position):
		return
	if kind == "drone":
		var projectile := EnemyProjectile.new()
		projectile.position = position + facing * 12
		projectile.direction = facing
		projectile.damage = config.damage
		level.add_child(projectile)
	else:
		player.health.apply_damage(config.damage, str(get_instance_id()))

func update_visual() -> void:
	if visual == null: return
	visual.set_facing(facing)
	visual.set_motion(velocity.length() > 1.0, state == "CHASE", false)
	visual.set_status(&"stunned", state == "STUNNED")
	visual.set_status(&"alert", state in ["SUSPICIOUS", "CHASE", "ATTACK"])

func _draw() -> void:
	var orange := Color("f4b860")
	if kind == "camera":
		draw_rect(Rect2(-9,-7,18,14), Color("75889a"))
		draw_line(Vector2.ZERO, facing * 16, Color("96a8b8") if state == "STUNNED" else orange, 5)
	if detection > 0.02:
		draw_rect(Rect2(-12,-38,24,3), Color("0b1421"))
		draw_rect(Rect2(-12,-38,24*detection,3), Color("f56b73") if detection >= 1.0 else orange)
	if state == "ATTACK" and attack_clock < config.windup:
		draw_arc(Vector2.ZERO, config.attack_range, facing.angle()-0.6, facing.angle()+0.6, 20, Color("f56b73"), 2)
	if GameManager.debug_enabled and OS.is_debug_build():
		draw_debug()

func draw_debug() -> void:
	if visual != null:
		draw_string(ThemeDB.fallback_font, Vector2(-20,-51), visual.visual_state() + "/" + visual.direction, HORIZONTAL_ALIGNMENT_LEFT,-1,8,Color("b29bff"))
	var points := PackedVector2Array([Vector2.ZERO])
	for i in range(13):
		var angle: float = facing.angle() - deg_to_rad(config.fov * 0.5) + deg_to_rad(config.fov) * i / 12.0
		var end := global_position + Vector2.from_angle(angle) * config.vision_radius
		var hit := get_world_2d().direct_space_state.intersect_ray(PhysicsRayQueryParameters2D.create(global_position, end, 1))
		points.append((hit.position if not hit.is_empty() else end) - global_position)
	draw_colored_polygon(points, Color(1.0,0.7,0.33,0.12))
	var ray_end: Vector2 = level.player.global_position
	var ray_hit := get_world_2d().direct_space_state.intersect_ray(PhysicsRayQueryParameters2D.create(global_position, ray_end, 1))
	if not ray_hit.is_empty():
		ray_end = ray_hit.position
	draw_line(Vector2.ZERO, ray_end - global_position, Color(0.95,0.4,0.45,0.5),1)
	draw_circle(last_seen - global_position, 3, Color("ffb454"), false, 1)
	if route.size() > 1:
		var local := PackedVector2Array()
		for point in route:
			local.append(point - global_position)
		draw_polyline(local, Color("43d9e8"),1)
	for waypoint in patrol:
		draw_circle(waypoint-position,3,Color("1dbfaf"),false,1)
	draw_string(ThemeDB.fallback_font,Vector2(-20,-41),state,HORIZONTAL_ALIGNMENT_LEFT,-1,9,Color.WHITE)
