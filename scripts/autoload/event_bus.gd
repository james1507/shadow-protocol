extends Node

signal noise_emitted(at: Vector2, radius: float, kind: String)
signal alert_raised(at: Vector2, alert_id: int)
signal inventory_changed
signal door_unlocked(id: String)
signal objective_completed(id: String)
signal level_completed(index: int)
signal notification(message: String)
var events: Array[Dictionary] = []
var alert_serial: int = 0

func record(actor: String, from: String, to: String, reason: String) -> void:
	events.append({"time": Time.get_ticks_msec(), "actor": actor, "from": from, "to": to, "reason": reason})
	if events.size() > 50:
		events.pop_front()

func raise_alert(at: Vector2) -> void:
	alert_serial += 1
	alert_raised.emit(at, alert_serial)

func dump_events() -> void:
	for entry in events:
		print("AI_EVENT ", JSON.stringify(entry))
