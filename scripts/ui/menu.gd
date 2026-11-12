extends Control

@export_enum("main", "results", "settings", "credits") var screen: String = "main"
var content: VBoxContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = UIStyle.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content = VBoxContainer.new()
	content.position = Vector2(36, 28)
	content.size = Vector2(280, 310)
	content.add_theme_constant_override("separation", 5)
	add_child(content)
	content.add_child(UIStyle.label("NIGHTFALL DIVISION   /   OPERATIONS", 10, UIStyle.CYAN))
	content.add_child(UIStyle.label("SHADOW\nPROTOCOL" if screen == "main" else "SHADOW PROTOCOL", 30 if screen == "main" else 21))
	content.add_child(UIStyle.label("BLACKSITE BREACH", 12, UIStyle.MUTED))
	if screen == "main":
		content.add_child(UIStyle.label("Recover the research. Leave no trace.", 11, UIStyle.MUTED))
		content.add_child(UIStyle.button("01   NEW OPERATION", GameManager.new_game))
		var continue_button := UIStyle.button("02   CONTINUE", GameManager.continue_game)
		continue_button.disabled = SaveManager.read_save("", false).is_empty()
		content.add_child(continue_button)
		content.add_child(UIStyle.button("03   SETTINGS", func(): get_tree().change_scene_to_file("res://scenes/menus/settings_menu.tscn")))
		content.add_child(UIStyle.button("04   CREDITS", func(): get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")))
		if OS.is_debug_build():
			var lab := UIStyle.button("CHARACTER LAB", func(): get_tree().change_scene_to_file("res://scenes/dev/character_showcase.tscn"))
			lab.position = Vector2(365,325)
			add_child(lab)
		content.add_child(UIStyle.button("05   QUIT", GameManager.quit_game))
	elif screen == "settings":
		content.add_child(UIStyle.label("SETTINGS", 20, UIStyle.CYAN))
		SettingsPanel.populate(content)
		content.add_child(UIStyle.button("BACK", GameManager.menu))
	elif screen == "credits":
		content.add_child(UIStyle.label("OPERATIONS DOSSIER", 18, UIStyle.CYAN))
		content.add_child(UIStyle.label("Original code, geometry and synthesized audio.\nMIT license · Godot Engine (MIT).\nAI-assisted implementation with Codex.\nNo third-party asset packs included.\nOptional CC0 publisher links: docs/ASSET_SOURCES.md", 11, UIStyle.MUTED))
		content.add_child(UIStyle.button("LICENSE NOTICES", show_licenses))
		content.add_child(UIStyle.button("BACK", GameManager.menu))
	elif screen == "results":
		var result: Dictionary = GameManager.last_result
		content.add_child(UIStyle.label("MISSION COMPLETE" if GameManager.level_index == 2 else "SECTOR CLEARED", 22, UIStyle.CYAN))
		if not result.is_empty():
			content.add_child(UIStyle.label("%s  /  %.1fs" % [result.grade, result.time], 17))
			content.add_child(UIStyle.label("Detections %d   Damage %.0f   EMP %d\nGuards stunned %d   Alerts %d" % [result.metrics.detections, result.metrics.damage, result.metrics.emp, result.metrics.stuns, result.metrics.alerts], 11, UIStyle.MUTED))
			if GameManager.level_index == 2:
				var total := 0.0
				for entry in GameManager.results:
					total += entry.time
				content.add_child(UIStyle.label(("Ghost extraction. No trace left." if result.undetected else "Research secured. You made it out.") + "\nRun total: %.1fs" % total, 11))
		if GameManager.level_index < 2:
			content.add_child(UIStyle.button("NEXT MISSION", func():
				GameManager.level_index += 1
				GameManager.pending_save = SaveManager.read_save()
				GameManager.start_level()))
		content.add_child(UIStyle.button("RETRY MISSION", func():
			GameManager.results.pop_back()
			GameManager.start_level()))
		content.add_child(UIStyle.button("MAIN MENU", GameManager.menu))
	else:
		content.add_child(UIStyle.label(screen.to_upper(), 20, UIStyle.CYAN))
		content.add_child(UIStyle.button("BACK TO OPERATIONS", GameManager.menu))
	for child in content.get_children():
		if child is Button:
			child.grab_focus()
			break
	queue_redraw()

func show_licenses() -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "License notices"
	var text := RichTextLabel.new()
	text.custom_minimum_size = Vector2(520, 230)
	text.text = FileAccess.get_file_as_string("res://LICENSE") + "\nGodot Engine\n" + Engine.get_license_text()
	for license_name in Engine.get_license_info():
		text.text += "\n" + license_name + "\n" + str(Engine.get_license_info()[license_name])
	dialog.add_child(text)
	add_child(dialog)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.canceled.connect(dialog.queue_free)
	dialog.popup_centered()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("0b1421"))
	# Original schematic artwork; geometry is decorative, never gameplay evidence.
	for x in range(340, 640, 16):
		draw_line(Vector2(x, 0), Vector2(x, 360), Color("122532"))
	for y in range(0, 360, 16):
		draw_line(Vector2(340, y), Vector2(640, y), Color("122532"))
	for i in range(7):
		var rect := Rect2(365 + (i % 3) * 68, 54 + (i / 3) * 81, 55, 65)
		draw_rect(rect, Color("19303f"))
		draw_rect(rect, Color("365162"), false, 1)
	draw_circle(Vector2(470, 180), 43, Color("43d9e8"), false, 1)
	draw_line(Vector2(470, 125), Vector2(470, 235), Color("43d9e8"))
	draw_line(Vector2(415, 180), Vector2(525, 180), Color("43d9e8"))
	draw_string(ThemeDB.fallback_font, Vector2(370, 310), "SECTOR 07   /   SIGNAL ENCRYPTED", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, UIStyle.MUTED)
