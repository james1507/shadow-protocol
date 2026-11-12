extends Node

var values: Dictionary = {"master": 0.75, "sfx": 0.7, "music": 0.5, "fullscreen": false, "shake": true}

func _ready() -> void:
	var config := ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		for key in values:
			var loaded: Variant = config.get_value("settings", key, values[key])
			if typeof(loaded) == typeof(values[key]):
				values[key] = loaded
	apply()

func apply() -> void:
	for key in ["master", "sfx", "music"]:
		values[key] = clampf(float(values[key]), 0.0, 1.0)
		var index := AudioServer.get_bus_index(key.capitalize() if key != "sfx" else "SFX")
		if index >= 0:
			AudioServer.set_bus_volume_db(index, linear_to_db(maxf(values[key], 0.0001)))
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if values.fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)

func save() -> void:
	var config := ConfigFile.new()
	for key in values:
		config.set_value("settings", key, values[key])
	var error := config.save("user://settings.cfg")
	if error != OK:
		EventBus.notification.emit("Settings could not be saved: " + error_string(error))
	apply()
