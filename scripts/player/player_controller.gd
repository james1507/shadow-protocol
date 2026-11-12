class_name PlayerController
extends CharacterBody2D

@export var stats: ActorStats = preload("res://config/balance/player.tres")
@onready var health: HealthComponent = $HealthComponent
@onready var stamina: StaminaComponent = $StaminaComponent
var facing: Vector2 = Vector2.RIGHT
var crouching: bool = false
var sprinting: bool = false
var animation_time: float = 0.0
var attack_timer: float = 0.0
var noise_timer: float = 0.0
var inventory: Dictionary = {"keycards": [], "emp_charges": 1, "data_chip_collected": false}
var level: Node2D
var body_texture: Texture2D
var step_timer: float = 0.0
var action_flash: float = 0.0

func _ready() -> void:
	add_to_group("player")
	health.maximum = stats.max_health
	health.invulnerability = stats.invulnerability
	stamina.stats = stats
	body_texture = AssetLibrary.texture("player_body")
	var animation := Animation.new()
	animation.length = 0.55
	var track := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track, NodePath(".:action_flash"))
	animation.track_insert_key(track, 0.0, 1.0)
	animation.track_insert_key(track, 0.55, 0.0)
	var library := AnimationLibrary.new()
	library.add_animation("attack", animation)
	$AnimationPlayer.add_animation_library("", library)

func movement(direction: Vector2, speed: float) -> Vector2:
	return direction.limit_length() * speed

func _physics_process(delta: float) -> void:
	if health.dead:
		velocity = Vector2.ZERO
		return
	animation_time += delta
	attack_timer = maxf(0.0, attack_timer - delta)
	noise_timer = maxf(0.0, noise_timer - delta)
	step_timer = maxf(0.0, step_timer - delta)
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	crouching = Input.is_action_pressed("crouch")
	sprinting = stamina.step(delta, direction != Vector2.ZERO and Input.is_action_pressed("sprint") and not crouching)
	velocity = movement(direction, stats.crouch_speed if crouching else (stats.sprint_speed if sprinting else stats.walk_speed))
	move_and_slide()
	if velocity.length() > 1.0 and step_timer <= 0.0:
		step_timer = 0.65 if crouching else 0.4
		AudioManager.play_sfx("step")
	var aim := get_global_mouse_position() - global_position
	if aim.length() > 3.0:
		facing = aim.normalized()
	if sprinting and noise_timer <= 0.0:
		EventBus.noise_emitted.emit(global_position, 155.0, "sprint")
		noise_timer = 0.6
	if is_instance_valid(level) and level.has_method("player_actions"):
		level.player_actions(self)
	queue_redraw()

func _draw() -> void:
	var bob: float = sin(animation_time * 15.0) * 1.0 if velocity.length() > 0.0 else sin(animation_time * 3.0) * 0.3
	draw_circle(Vector2(1, 5), 10, Color(0, 0, 0, 0.35))
	var color := Color("43d9e8")
	if health.immunity > 0.0 and int(animation_time * 18) % 2 == 0:
		color = Color.WHITE
	draw_set_transform(Vector2(0, bob), facing.angle())
	draw_rect(Rect2(-7, -7, 13, 14), Color("1d6476"))
	draw_rect(Rect2(-4, -6, 9, 12), color)
	draw_rect(Rect2(1, -5, 5, 10), Color("e7f0f5"))
	draw_rect(Rect2(5, -2, 11, 4), Color("43d9e8"))
	if crouching:
		draw_arc(Vector2.ZERO, 12, 0, TAU, 24, color, 1)
	if action_flash > 0.5:
		draw_arc(Vector2.ZERO, 30, -0.8, 0.8, 16, Color("e7f0f5"), 3)
	if body_texture != null:
		draw_texture_rect(body_texture, Rect2(-10,-10,20,20), false)
