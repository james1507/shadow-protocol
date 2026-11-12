class_name WorldItem
extends Area2D

@export_enum("keycard", "terminal", "door", "health", "emp", "chip", "checkpoint", "extraction") var kind: String = "keycard"
var item_id: String = ""
var key: String = ""
var objective: String = ""
var level: Node2D
var used: bool = false
var opened: bool = false
var hack_progress: float = 0.0
var hack_actor: PlayerController
var hack_start_health: float = 0.0
var hacking_seconds: float = 3.0
var pulse: float = 0.0
var door_body: StaticBody2D
var door_visual: float = 0.0
var item_texture: Texture2D

func _ready() -> void:
	add_to_group("interactables")
	item_texture = AssetLibrary.texture("keycard_" + key if kind == "keycard" else ("data_chip" if kind == "chip" else kind))
	if kind == "door":
		door_body = StaticBody2D.new()
		door_body.collision_layer = 1
		door_body.collision_mask = 0
		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = Vector2(32, 64)
		shape.shape = rect
		shape.position.y = 16
		door_body.add_child(shape)
		add_child(door_body)
		level.world.set_door(position, true)

func can_interact(actor: PlayerController) -> bool:
	return not actor.health.dead and not used and not (kind == "door" and opened)

func get_interaction_label() -> String:
	match kind:
		"keycard": return "Pick up %s Keycard" % key.capitalize()
		"terminal": return "Hack Terminal · %.0fs" % hacking_seconds
		"door": return "Open Door" + (" · " + key.capitalize() if key != "" else "")
		"health": return "Restore Health +30"
		"emp": return "Collect EMP Charge"
		"chip": return "Collect Research Data"
		"checkpoint": return "Save Checkpoint"
		"extraction": return "Extract"
	return "Interact"

func interact(actor: PlayerController) -> bool:
	if not can_interact(actor) or get_tree().paused or actor.global_position.distance_to(global_position) > actor.stats.interaction_range or not level.interaction_los(actor, self):
		return false
	if objective != "" and not level.mission.can_complete(objective):
		EventBus.notification.emit("First: " + level.mission.next_title())
		return false
	match kind:
		"door":
			var authorized: bool = key == "" or (key in actor.inventory.keycards if key in ["blue", "red"] else key in level.mission.completed)
			if not authorized:
				EventBus.notification.emit("Access denied · " + key.capitalize() + " required")
				return false
			open_door()
		"terminal":
			if not is_instance_valid(hack_actor):
				hack_actor = actor
				hack_start_health = actor.health.current
				hack_progress = 0.0
				AudioManager.play_sfx("terminal")
		"checkpoint":
			level.checkpoint(global_position)
		"extraction":
			return level.extract()
		_:
			if kind == "health":
				actor.health.heal(30.0)
			elif kind == "emp":
				if actor.inventory.emp_charges >= 3:
					EventBus.notification.emit("EMP capacity full")
					return false
				actor.inventory.emp_charges = mini(3, actor.inventory.emp_charges + 1)
			elif kind == "keycard" and key not in actor.inventory.keycards:
				actor.inventory.keycards.append(key)
			elif kind == "chip":
				actor.inventory.data_chip_collected = true
			consume()
			level.mission.complete(objective)
			if kind == "chip":
				level.checkpoint(global_position + Vector2(-24, 0))
			EventBus.inventory_changed.emit()
			AudioManager.play_sfx("pickup")
	return true

func consume() -> void:
	used = true
	visible = false
	level.picked_ids[item_id] = true

func open_door() -> void:
	if opened:
		return
	opened = true
	door_body.get_child(0).set_deferred("disabled", true)
	level.world.set_door(position, false)
	level.opened_ids[item_id] = true
	EventBus.door_unlocked.emit(item_id)
	AudioManager.play_sfx("door")

func _physics_process(delta: float) -> void:
	pulse += delta
	door_visual = move_toward(door_visual, 1.0 if opened else 0.0, delta * 3.0)
	if is_instance_valid(hack_actor):
		if hack_actor.health.dead or hack_actor.global_position.distance_to(global_position) > 40.0 or hack_actor.health.current < hack_start_health:
			hack_actor = null
			hack_progress = 0.0
			EventBus.notification.emit("Hack canceled · stay close and avoid damage")
		else:
			hack_progress += delta / hacking_seconds
			if hack_progress >= 1.0:
				hack_actor = null
				used = true
				level.picked_ids[item_id] = true
				level.mission.complete(objective)
				level.terminal_completed(self)
	queue_redraw()

func _draw() -> void:
	var cyan := Color("43d9e8")
	var color := Color("f56b73") if key == "red" else cyan
	var bob := Vector2(0, sin(pulse * 3.0) * 2.0)
	match kind:
		"door":
			draw_rect(Rect2(-18, -17, 36, 66), Color("0b1421"))
			draw_rect(Rect2(-16, -16, 32, 64), Color("3c5365"), false, 2)
			var width: float = 14.0 * (1.0 - door_visual)
			draw_rect(Rect2(-14, -14, width, 60), Color("42596a"))
			draw_rect(Rect2(14 - width, -14, width, 60), Color("42596a"))
			draw_line(Vector2(0, -10), Vector2(0, 42), cyan if opened else color, 2)
		"terminal":
			draw_rect(Rect2(-12,-10,24,23), Color("304859"))
			draw_rect(Rect2(-9,-8,18,12), Color("1dbfaf") if used else cyan)
			draw_line(Vector2(-5,-4), Vector2(5,-4), Color("0b1421"), 2)
			draw_rect(Rect2(-8,8,16,2), cyan)
			if is_instance_valid(hack_actor):
				draw_rect(Rect2(-17,-20,34,4), Color("0b1421"))
				draw_rect(Rect2(-17,-20,34 * hack_progress,4), cyan)
		"keycard":
			draw_rect(Rect2(bob + Vector2(-8,-5), Vector2(16,10)), color)
			draw_rect(Rect2(bob + Vector2(-5,-3), Vector2(4,6)), Color("0b1421"))
		"health":
			draw_rect(Rect2(bob + Vector2(-9,-8), Vector2(18,16)), Color("d8eee2"))
			draw_line(bob + Vector2(-5,0), bob + Vector2(5,0), Color("1dbfaf"), 3)
			draw_line(bob + Vector2(0,-5), bob + Vector2(0,5), Color("1dbfaf"), 3)
		"emp", "chip":
			draw_circle(bob, 10, Color("163c4e"))
			draw_arc(bob, 9, 0, TAU, 6 if kind == "chip" else 24, cyan, 2)
			draw_line(bob + Vector2(-3,4), bob + Vector2(3,-4), cyan, 3)
		"checkpoint":
			draw_arc(Vector2.ZERO, 15, pulse, pulse + PI * 1.6, 30, Color("1dbfaf"), 2)
			draw_string(ThemeDB.fallback_font, Vector2(-7,4), "C", HORIZONTAL_ALIGNMENT_LEFT,-1,12,cyan)
		"extraction":
			draw_rect(Rect2(-23,-23,46,46), Color(0.11,0.75,0.68,0.14))
			draw_rect(Rect2(-23,-23,46,46), Color("1dbfaf"), false,2)
			draw_polyline(PackedVector2Array([Vector2(-8,5), Vector2(0,-5), Vector2(8,5)]), cyan, 3)
			draw_string(ThemeDB.fallback_font,Vector2(-13,37),"EXIT",HORIZONTAL_ALIGNMENT_LEFT,-1,10,cyan)
	if item_texture != null:
		draw_texture_rect(item_texture, Rect2(-12,-12,24,24),false)
