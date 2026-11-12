class_name AttackService
extends Node

var level: Node2D
var windup: float = -1.0
var actor: PlayerController
var hit_targets: Dictionary = {}

func attack(source: PlayerController) -> bool:
	if source.health.dead or source.attack_timer > 0.0:
		return false
	source.attack_timer = source.stats.attack_cooldown
	source.get_node("AnimationPlayer").play("attack")
	actor = source
	windup = 0.15
	hit_targets.clear()
	return true

func apply_once(enemy: Node2D, duration: float) -> bool:
	if not is_instance_valid(enemy) or not enemy.has_method("stun") or hit_targets.has(enemy.get_instance_id()):
		return false
	hit_targets[enemy.get_instance_id()] = true
	enemy.stun(duration)
	level.metrics.stuns += 1
	AudioManager.play_sfx("stun")
	return true

func _physics_process(delta: float) -> void:
	if windup < 0.0:
		return
	windup -= delta
	if windup <= 0.0 and is_instance_valid(actor) and not actor.health.dead:
		windup = -1.0
		for enemy in get_tree().get_nodes_in_group("enemies"):
			var offset: Vector2 = enemy.global_position - actor.global_position
			if offset.length() <= actor.stats.attack_range and actor.facing.dot(offset.normalized()) >= 0.35 and level.clear_los(actor.global_position, enemy.global_position):
				apply_once(enemy, actor.stats.stun_duration)
		EventBus.noise_emitted.emit(actor.global_position, 90.0, "baton")

func emp(source: PlayerController) -> bool:
	if source.health.dead or source.inventory.emp_charges <= 0:
		EventBus.notification.emit("No EMP charges")
		return false
	source.inventory.emp_charges -= 1
	level.metrics.emp += 1
	EventBus.inventory_changed.emit()
	var effect := PulseEffect.new()
	effect.position = source.global_position
	level.add_child(effect)
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.global_position.distance_to(source.global_position) <= 110.0:
			enemy.stun(5.0 if enemy.kind in ["camera", "drone"] else (1.0 if enemy.kind == "heavy" else 2.0))
	AudioManager.play_sfx("emp")
	return true
