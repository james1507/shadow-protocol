class_name VisionSensor
extends RefCounted

static func inside_fov(origin: Vector2, facing: Vector2, target: Vector2, radius: float, fov: float) -> bool:
	var offset := target - origin
	if offset.length() > radius:
		return false
	return offset.length() < 0.01 or facing.dot(offset.normalized()) >= cos(deg_to_rad(fov * 0.5))

static func visible(enemy: Node2D, player: PlayerController) -> bool:
	if player.health.dead or player.health.immunity > 0.6:
		return false
	var radius: float = enemy.config.vision_radius * (0.7 if player.crouching else 1.0)
	return inside_fov(enemy.global_position, enemy.facing, player.global_position, radius, enemy.config.fov) and enemy.level.clear_los(enemy.global_position, player.global_position)
