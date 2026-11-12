extends Node

const SAVE_PATH := "user://save_v1.json"
var last_error: String = ""
var storage_path: String = SAVE_PATH

func valid(data: Variant) -> bool:
	if not data is Dictionary:
		return false
	if data.get("version") != 1 or not data.get("level") is float and not data.get("level") is int:
		return false
	var index: int = int(data.level)
	if data.has("finished") and not data.finished is bool:
		return false
	var finished: bool = data.get("finished", false)
	if index < 0 or index > 2 or float(data.level) != index:
		return false
	for field in ["health", "stamina"]:
		if not (data.get(field) is float or data.get(field) is int) or not is_finite(float(data[field])) or data[field] < 0 or data[field] > 100:
			return false
	if data.health <= 0:
		return false
	if not data.get("position") is Array or data.position.size() != 2:
		return false
	for coordinate in data.position:
		if not (coordinate is float or coordinate is int) or not is_finite(float(coordinate)) or coordinate < 32 or coordinate > 1664:
			return false
	if not data.get("inventory") is Dictionary:
		return false
	var inventory: Dictionary = data.inventory
	if not inventory.get("keycards") is Array or inventory.keycards.any(func(key: Variant): return key not in ["blue", "red"]):
		return false
	if not (inventory.get("emp_charges") is float or inventory.get("emp_charges") is int) or inventory.emp_charges < 0 or inventory.emp_charges > 3 or fmod(float(inventory.emp_charges), 1.0) != 0:
		return false
	if not inventory.get("data_chip_collected") is bool:
		return false
	for field in ["objectives", "pickups", "doors"]:
		if not data.get(field) is Array or data[field].size() > 100 or data[field].any(func(id: Variant): return not id is String or id.length() > 80):
			return false
	if not data.get("checkpoint") is String or not data.get("results") is Array or data.results.size() > 3:
		return false
	if data.checkpoint not in ["field", "mission_start"]:
		return false
	var definition: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/missions/level_0%d.json" % (index + 1)))
	var cell := Vector2i(int(data.position[0]) / 32, int(data.position[1]) / 32)
	if cell.x < 1 or cell.y < 1 or cell.x >= definition.size[0] - 1 or cell.y >= definition.size[1] - 1:
		return false
	for segment in definition.walls:
		if cell.x >= segment[0] and cell.x <= segment[2] and cell.y >= segment[1] and cell.y <= segment[3]:
			return false
	for cover in definition.cover:
		if cell == Vector2i(cover[0], cover[1]):
			return false
	for field in ["objectives", "pickups", "doors"]:
		var unique: Dictionary = {}
		for id in data[field]:
			if unique.has(id):
				return false
			unique[id] = true
	for id in data.objectives:
		var found := false
		for objective in definition.objectives:
			if objective.id == id:
				found = true
				for prerequisite in objective.requires:
					if prerequisite not in data.objectives:
						return false
		if not found:
			return false
	for field in ["pickups", "doors"]:
		for id in data[field]:
			if not definition.objects.any(func(object: Dictionary): return object.id == id and ((object.kind == "door") == (field == "doors"))):
				return false
	for result in data.results:
		if not result is Dictionary or not result.get("title") is String or result.get("grade") not in ["GOLD", "SILVER", "BRONZE"] or not result.get("metrics") is Dictionary:
			return false
		for key in ["level", "time"]:
			if not (result.get(key) is float or result.get(key) is int) or not is_finite(float(result[key])) or result[key] < 0:
				return false
		if result.level > index or (result.level == index and not finished):
			return false
		for key in ["detections", "damage", "alerts", "emp", "stuns"]:
			if not (result.metrics.get(key) is float or result.metrics.get(key) is int) or not is_finite(float(result.metrics[key])) or result.metrics[key] < 0:
				return false
	if finished:
		if index != 2 or data.results.size() != 3:
			return false
		for result_index in range(3):
			if data.results[result_index].level != result_index:
				return false
		if definition.objectives.any(func(objective: Dictionary): return objective.id not in data.objectives):
			return false
	if data.has("elapsed") and (not (data.elapsed is float or data.elapsed is int) or not is_finite(float(data.elapsed)) or data.elapsed < 0):
		return false
	if data.has("metrics"):
		if not data.metrics is Dictionary:
			return false
		for key in ["detections", "damage", "alerts", "emp", "stuns"]:
			if not (data.metrics.get(key) is float or data.metrics.get(key) is int) or not is_finite(float(data.metrics[key])) or data.metrics[key] < 0:
				return false
	return true

func write_save(data: Dictionary, path: String = "") -> bool:
	if path == "":
		path = storage_path
	if not valid(data):
		last_error = "Invalid save payload"
		return false
	var temp := path + ".tmp"
	var file := FileAccess.open(temp, FileAccess.WRITE)
	if file == null:
		last_error = "Cannot open temporary save: " + error_string(FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(data))
	file.flush()
	var error := file.get_error()
	file.close()
	if error != OK:
		last_error = "Cannot write save: " + error_string(error)
		return false
	# Same-filesystem rename is atomic; existing valid file survives any write failure.
	error = DirAccess.rename_absolute(ProjectSettings.globalize_path(temp), ProjectSettings.globalize_path(path))
	if error != OK:
		last_error = "Cannot replace save: " + error_string(error)
		return false
	last_error = ""
	return true

func read_save(path: String = "", preserve_invalid: bool = true) -> Dictionary:
	if path == "":
		path = storage_path
	if not FileAccess.file_exists(path):
		return {}
	var text := FileAccess.get_file_as_string(path)
	var parser := JSON.new()
	var error := parser.parse(text)
	var parsed: Variant = parser.data
	if error != OK or not valid(parsed):
		last_error = "Corrupt or unsupported save; original preserved"
		if preserve_invalid:
			var backup := path + ".invalid-" + str(Time.get_unix_time_from_system()).replace(".", "-")
			DirAccess.copy_absolute(ProjectSettings.globalize_path(path), ProjectSettings.globalize_path(backup))
		return {}
	last_error = ""
	return parsed
