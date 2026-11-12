class_name PulseEffect
extends Node2D

var time: float = 0.0

func _physics_process(delta: float) -> void:
	time += delta
	if time >= 0.5:
		queue_free()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, time * 220.0, Color(0.26,0.85,0.91,0.15 * (1.0 - time * 2.0)))
	draw_arc(Vector2.ZERO, time * 220.0, 0, TAU, 64, Color(0.26,0.85,0.91,1.0 - time * 2.0), 3)
