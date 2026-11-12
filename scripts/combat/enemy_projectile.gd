class_name EnemyProjectile
extends CharacterBody2D

var direction := Vector2.RIGHT
var damage: float = 10.0
var lifetime: float = 2.0

func _ready() -> void:
	add_to_group("projectiles")
	collision_layer = 128
	collision_mask = 3
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 3.0
	shape.shape = circle
	add_child(shape)

func _physics_process(delta: float) -> void:
	lifetime -= delta
	var collision := move_and_collide(direction * 210.0 * delta)
	if collision:
		var target := collision.get_collider()
		if target is PlayerController:
			target.health.apply_damage(damage, "drone pulse")
		queue_free()
	elif lifetime <= 0.0:
		queue_free()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO,3,Color("f56b73"))
	draw_line(-direction*8,Vector2.ZERO,Color("ffb454"),2)
