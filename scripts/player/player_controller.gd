class_name PlayerController
extends CharacterBody2D

@export var stats: ActorStats = preload("res://config/balance/player.tres")
@onready var health: HealthComponent = $HealthComponent
@onready var stamina: StaminaComponent = $StaminaComponent
var facing: Vector2 = Vector2.RIGHT
var crouching: bool = false
var sprinting: bool = false
var attack_timer: float = 0.0
var noise_timer: float = 0.0
var inventory: Dictionary = {"keycards": [], "emp_charges": 1, "data_chip_collected": false}
var level: Node2D
@onready var visual: CharacterVisual = $CharacterVisual
var previous_mouse: Vector2
var mouse_aim_active: bool = false
var step_timer: float = 0.0

func _ready() -> void:
	add_to_group("player")
	health.maximum = stats.max_health
	health.invulnerability = stats.invulnerability
	stamina.stats = stats
	previous_mouse = get_viewport().get_mouse_position()
	health.damaged.connect(visual.play_hurt)
	health.died.connect(visual.play_ko)

func movement(direction: Vector2, speed: float) -> Vector2:
	return direction.limit_length() * speed

func _physics_process(delta: float) -> void:
	if health.dead:
		velocity = Vector2.ZERO
		visual.play_ko()
		return
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
	var mouse := get_viewport().get_mouse_position()
	var aim := get_global_mouse_position() - global_position
	if mouse.distance_to(previous_mouse) > 0.5:
		mouse_aim_active = true
	if mouse_aim_active and aim.length() > 6.0:
		facing = aim.normalized()
	elif direction != Vector2.ZERO:
		facing = direction.normalized()
	previous_mouse = mouse
	visual.set_facing(facing)
	visual.set_motion(velocity.length() > 1.0, sprinting, crouching)
	if sprinting and noise_timer <= 0.0:
		EventBus.noise_emitted.emit(global_position, 155.0, "sprint")
		noise_timer = 0.6
	if is_instance_valid(level) and level.has_method("player_actions"):
		level.player_actions(self)
	queue_redraw()
