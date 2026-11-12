class_name CharacterVisual
extends Node2D

signal visual_animation_completed(action: StringName)
@export var actor_key: StringName = &"player_agent"
var profile: CharacterVisualProfile
var direction: String = "down"
var moving: bool = false
var sprinting: bool = false
var crouching: bool = false
var statuses: Dictionary = {}
var action: String = ""
var action_left: float = 0.0
var knocked_out: bool = false
var clock: float = 0.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	set_profile(CharacterVisualRegistry.resolve(actor_key))
	sprite.animation_finished.connect(_animation_finished)

func set_profile(value: CharacterVisualProfile) -> void:
	profile = value
	sprite.sprite_frames = profile.frames
	sprite.offset = Vector2(16, 16) - profile.pivot_px
	scale = Vector2.ONE * maxi(1, profile.pixel_scale)
	$EquipmentAnchor.position = profile.equipment_offset
	reset_visuals()

func set_facing(value: Vector2) -> void:
	if value.length_squared() < 36.0 / 10000.0:
		return
	# Exact diagonals retain last facing; no invented diagonal frames.
	if is_equal_approx(absf(value.x), absf(value.y)):
		return
	direction = ("right" if value.x > 0 else "left") if absf(value.x) > absf(value.y) else ("down" if value.y > 0 else "up")
	_refresh()

func set_motion(is_moving: bool, is_sprinting: bool, is_crouching: bool) -> void:
	moving = is_moving
	sprinting = is_sprinting
	crouching = is_crouching
	_refresh()

func play_attack() -> void:
	_start_action("attack", 0.38)

func play_hurt() -> void:
	_start_action("hurt", 0.22)

func play_ko() -> void:
	if knocked_out:
		return
	knocked_out = true
	action = ""
	action_left = 0.0
	statuses.clear()
	sprite.modulate = Color.WHITE
	_refresh()

func _start_action(value: String, seconds: float) -> void:
	if knocked_out or statuses.get("stunned", false) or (action == "hurt" and value != "hurt"):
		return
	action = value
	action_left = seconds
	_refresh()

func set_status(status: StringName, enabled: bool) -> void:
	if knocked_out:
		return
	if enabled:
		statuses[str(status)] = true
	else:
		statuses.erase(str(status))
	if status == &"stunned" and enabled:
		action = ""
		action_left = 0.0
	_refresh()

func reset_visuals() -> void:
	knocked_out = false
	action = ""
	action_left = 0.0
	statuses.clear()
	moving = false
	sprinting = false
	crouching = false
	clock = 0.0
	sprite.position = Vector2.ZERO
	sprite.modulate = Color.WHITE
	_refresh()

func visual_state() -> String:
	if knocked_out: return "ko"
	if statuses.get("stunned", false): return "stunned"
	if action != "": return action
	if statuses.get("interact", false): return "interact"
	if crouching: return "crouch"
	if moving: return "sprint" if sprinting else "walk"
	return "idle"

func _refresh() -> void:
	if not is_instance_valid(sprite) or profile == null:
		return
	var state := visual_state()
	var clip := state + "_" + direction
	if not profile.frames.has_animation(clip):
		clip = "idle_" + direction
	if str(sprite.animation) != clip:
		sprite.play(clip)
	sprite.speed_scale = 1.5 if state == "sprint" else 1.0
	sprite.position.y = 1 if crouching and state != "ko" else 0
	queue_redraw()

func _process(delta: float) -> void:
	clock += delta
	if action_left > 0.0:
		action_left = maxf(0.0, action_left - delta)
		if action_left == 0.0:
			var completed := action
			action = ""
			_refresh()
			visual_animation_completed.emit(StringName(completed))
	sprite.modulate = Color("fff0eb") * 1.45 if action == "hurt" else Color.WHITE
	queue_redraw()

func _animation_finished() -> void:
	if knocked_out:
		visual_animation_completed.emit(&"ko")

func _draw() -> void:
	if profile == null:
		return
	draw_set_transform(Vector2.ZERO, 0, Vector2(1, profile.shadow_size.y / profile.shadow_size.x))
	draw_circle(Vector2.ZERO, profile.shadow_size.x, Color(0.015, 0.025, 0.05, 0.65))
	draw_set_transform(Vector2.ZERO)
	var state := visual_state()
	var aim := {"up":Vector2.UP,"down":Vector2.DOWN,"left":Vector2.LEFT,"right":Vector2.RIGHT}[direction] as Vector2
	if state == "attack":
		draw_arc(Vector2(0,-7), 21, aim.angle()-0.8, aim.angle()+0.8, 12, profile.accent, 2)
		draw_line(Vector2(0,-7) + aim * 8, Vector2(0,-7) + aim * 22, Color("dfe7f1"), 2)
	if state == "stunned":
		for i in range(3):
			var at := Vector2.from_angle(clock * 3 + i * TAU / 3) * Vector2(11, 4) + Vector2(0, -26)
			draw_line(at, at + Vector2(2,-3), Color("b29bff"), 1)
		draw_arc(Vector2(0,-26), 8, clock * 2, clock * 2 + PI, 12, profile.accent, 1)
	if state == "interact":
		draw_rect(Rect2(aim * 9 + Vector2(-3,-12), Vector2(6,7)), Color("47dbb4"), false, 1)
	if state == "crouch":
		draw_arc(Vector2.ZERO, 11, 0, TAU, 24, profile.accent * Color(1,1,1,0.6), 1)
	if statuses.get("alert", false):
		draw_rect(Rect2(-1,-34,2,5), Color("f4b860"))
		draw_rect(Rect2(-1,-27,2,2), Color("f4b860"))
	if state == "ko":
		draw_arc(Vector2(0,-8), 8, clock, clock + PI * 1.5, 12, profile.accent, 1)
