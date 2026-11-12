extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func shot(path: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	var result := root.get_texture().get_image().save_png("res://docs/screenshots/" + path + ".png")
	print("V2 CAPTURE ",path," ",error_string(result))

func run() -> void:
	root.get_node("SaveManager").storage_path = "user://v2-capture-only.json"
	var game = root.get_node("GameManager")
	change_scene_to_file("res://scenes/dev/character_showcase.tscn")
	await scene_changed
	await create_timer(0.3).timeout
	await shot("character_showcase/idle")
	current_scene.actor_picker.select(3)
	current_scene.state_picker.select(2)
	current_scene.refresh()
	await shot("character_showcase/heavy_attack")
	current_scene.actor_picker.select(4)
	current_scene.state_picker.select(8)
	current_scene.refresh()
	await shot("character_showcase/drone_stunned")
	current_scene.actor_picker.select(1)
	current_scene.state_picker.select(4)
	current_scene.refresh()
	await shot("character_showcase/guard_ko")
	change_scene_to_file("res://scenes/menus/main_menu.tscn")
	await scene_changed
	await shot("v2-menu")
	for index in range(3):
		game.level_index = index
		game.pending_save.clear()
		game.start_level()
		await scene_changed
		# Frame near real actors/foreground, without changing game health or objectives.
		current_scene.player.get_node("Camera2D").position_smoothing_enabled = false
		if index == 0:
			Input.action_press("move_up")
			await create_timer(3.0).timeout
			Input.action_release("move_up")
		await create_timer(0.4).timeout
		await shot("v2-level-%d" % (index+1))
	game.debug_enabled = true
	await shot("v2-debug")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://v2-capture-only.json"))
	await game.quit_game()
