class_name StaminaComponent
extends Node

var stats: ActorStats = preload("res://config/balance/player.tres")
var current: float = 100.0
var recovery_delay: float = 0.0
var exhausted: bool = false

func step(delta: float, requested: bool) -> bool:
	if exhausted and current >= 10.0:
		exhausted = false
	var sprinting: bool = requested and not exhausted and current > 0.0
	if sprinting:
		current = maxf(0.0, current - stats.drain * delta)
		recovery_delay = stats.regen_delay
		exhausted = current <= 0.0
	else:
		var regeneration_time: float = maxf(0.0, delta - recovery_delay)
		recovery_delay = maxf(0.0, recovery_delay - delta)
		current = minf(stats.max_stamina, current + stats.regen * regeneration_time)
	return sprinting
