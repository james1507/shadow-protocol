class_name HealthComponent
extends Node

signal health_changed(current: float, maximum: float)
signal died
@export var maximum: float = 100.0
@export var invulnerability: float = 0.6
var current: float = 100.0
var immunity: float = 0.0
var dead: bool = false

func _physics_process(delta: float) -> void:
	immunity = maxf(0.0, immunity - delta)

func apply_damage(amount: float, _source_id: String = "") -> bool:
	if amount <= 0.0 or dead or immunity > 0.0:
		return false
	current = maxf(0.0, current - amount)
	immunity = invulnerability
	health_changed.emit(current, maximum)
	if current <= 0.0:
		die()
	return true

func heal(amount: float) -> void:
	if amount > 0.0 and not dead:
		current = minf(maximum, current + amount)
		health_changed.emit(current, maximum)

func die() -> void:
	if not dead:
		dead = true
		current = 0.0
		died.emit()
