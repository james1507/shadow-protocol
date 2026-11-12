class_name MissionManager
extends Node

var definitions: Array = []
var completed: Array = []

func can_complete(id: String) -> bool:
	for objective in definitions:
		if objective.id == id:
			for prerequisite in objective.requires:
				if prerequisite not in completed:
					return false
			return id not in completed
	return false

func complete(id: String) -> bool:
	if not can_complete(id):
		return false
	completed.append(id)
	EventBus.objective_completed.emit(id)
	return true

func all_complete() -> bool:
	return definitions.all(func(objective: Dictionary): return objective.id in completed)

func next_title() -> String:
	for objective in definitions:
		if objective.id not in completed:
			return objective.title
	return "Reach Extraction"
