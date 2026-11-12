extends Node

const LEVEL_PATHS: Array[String] = ["res://scenes/levels/level_01_access.tscn", "res://scenes/levels/level_02_vault.tscn", "res://scenes/levels/level_03_escape.tscn"]
var level_index: int = 0
var pending_save: Dictionary = {}
var results: Array = []
var debug_enabled: bool = false
var last_result: Dictionary = {}

func _ready() -> void:
	get_tree().auto_accept_quit = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit_game()

func quit_game() -> void:
	AudioManager.stop_all()
	await get_tree().create_timer(0.06, true, false, true).timeout
	get_tree().quit()

func new_game() -> void:
	results.clear()
	level_index = 0
	pending_save.clear()
	start_level()

func continue_game() -> void:
	var data := SaveManager.read_save()
	if data.is_empty():
		return
	pending_save = data
	level_index = int(data.level)
	results = data.results.duplicate(true)
	if data.get("finished", false):
		last_result = results.back()
		pending_save.clear()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/menus/results.tscn")
		return
	start_level()

func start_level() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(LEVEL_PATHS[level_index])

func menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func finish_level(result: Dictionary) -> void:
	last_result = result
	results.append(result)
	if level_index < 2:
		var next: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/missions/level_0%d.json" % (level_index + 2)))
		SaveManager.write_save({"version": 1, "level": level_index + 1, "checkpoint": "mission_start", "position": [next.spawn[0] * 32 + 16, next.spawn[1] * 32 + 16], "health": 100.0, "stamina": 100.0, "inventory": {"keycards": [], "emp_charges": 1, "data_chip_collected": level_index == 1}, "objectives": [], "pickups": [], "doors": [], "results": results.duplicate(true)})
	else:
		var level := get_tree().current_scene
		if is_instance_valid(level) and level.has_method("snapshot"):
			var data: Dictionary = level.snapshot(level.player.position)
			data.finished = true
			data.results = results.duplicate(true)
			if not SaveManager.write_save(data):
				EventBus.notification.emit(SaveManager.last_error)
	EventBus.level_completed.emit(level_index)
	get_tree().change_scene_to_file("res://scenes/menus/results.tscn")
