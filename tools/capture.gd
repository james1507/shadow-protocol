extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func shot(name: String) -> void:
	await process_frame
	await RenderingServer.frame_post_draw
	var path := "res://docs/screenshots/" + name + ".png"
	var result := root.get_texture().get_image().save_png(path)
	print("CAPTURE ",path," ",error_string(result))

func run() -> void:
	var game = root.get_node("GameManager")
	root.get_node("SaveManager").storage_path = "user://capture-only.json"
	change_scene_to_file("res://scenes/menus/main_menu.tscn")
	await scene_changed
	await shot("menu")
	game.new_game()
	await scene_changed
	Input.action_press("move_up")
	await create_timer(2.5).timeout
	Input.action_release("move_up")
	await shot("gameplay")
	change_scene_to_file("res://scenes/levels/test_arena.tscn")
	await scene_changed
	game.debug_enabled = true
	Input.action_press("move_up")
	await create_timer(3.0).timeout
	Input.action_release("move_up")
	await shot("debug")
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://capture-only.json"))
	paused = true
	game.quit_game()
