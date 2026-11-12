class_name SettingsPanel
extends RefCounted

static func populate(parent: VBoxContainer) -> void:
	for key in ["master", "sfx", "music"]:
		var row := HBoxContainer.new()
		var label := UIStyle.label(key.to_upper(), 10)
		label.custom_minimum_size.x = 55
		row.add_child(label)
		var slider := HSlider.new()
		slider.min_value = 0.0
		slider.max_value = 1.0
		slider.step = 0.05
		slider.value = SettingsManager.values[key]
		slider.custom_minimum_size.x = 120
		row.add_child(slider)
		var value := UIStyle.label("%d%%" % (slider.value * 100), 10)
		row.add_child(value)
		slider.value_changed.connect(func(amount: float):
			SettingsManager.values[key] = amount
			SettingsManager.save()
			value.text = "%d%%" % (amount * 100))
		parent.add_child(row)
	for key in ["fullscreen", "shake"]:
		var check := CheckButton.new()
		check.text = "FULLSCREEN" if key == "fullscreen" else "CAMERA SHAKE"
		check.button_pressed = SettingsManager.values[key]
		check.toggled.connect(func(enabled: bool):
			SettingsManager.values[key] = enabled
			SettingsManager.save())
		parent.add_child(check)
