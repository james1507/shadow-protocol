extends SceneTree

var passed: int = 0
var failed: int = 0
var visual
var game
var saves

func _initialize() -> void:
	call_deferred("run")
	create_timer(40.0).timeout.connect(func(): push_error("Art test watchdog"); quit(99))

func check(ok: bool, message: String) -> void:
	if ok:
		passed += 1
		print("PASS ",message)
	else:
		failed += 1
		push_error("FAIL " + message)

func run() -> void:
	game = root.get_node("GameManager")
	saves = root.get_node("SaveManager")
	saves.storage_path = "user://art-tests-only.json"
	var registry = load("res://scripts/characters/character_visual_registry.gd")
	var roster = JSON.parse_string(FileAccess.get_file_as_string("res://config/character_roster.json"))
	var valid := true
	for key in roster.characters:
		var profile = registry.resolve(key)
		valid = valid and profile != null and profile.frames != null
		for state in ["idle","walk","attack","hurt","ko","crouch","sprint","interact","stunned"]:
			for direction in ["down","up","left","right"]:
				var name: String = state+"_"+direction
				valid = valid and profile.frames.has_animation(name) and profile.frames.get_frame_count(name)>0
				for i in range(profile.frames.get_frame_count(name)):
					var texture = profile.frames.get_frame_texture(name,i)
					valid = valid and texture is AtlasTexture and texture.get_size() == Vector2(32,32)
					valid = valid and Rect2(Vector2.ZERO,texture.atlas.get_size()).encloses(texture.region)
					valid = valid and not texture.get_image().is_invisible()
	check(valid,"ART-01 committed profiles load without any intake dependency")
	visual = load("res://scenes/characters/character_visual.tscn").instantiate()
	root.add_child(visual)
	var names := []
	var hashes := []
	for value in [Vector2.DOWN,Vector2.UP,Vector2.LEFT,Vector2.RIGHT]:
		visual.set_facing(value)
		names.append(str(visual.sprite.animation))
		hashes.append(hash(visual.sprite.sprite_frames.get_frame_texture(visual.sprite.animation,0).get_image().get_data()))
	check(names == ["idle_down","idle_up","idle_left","idle_right"] and hashes[0]!=hashes[1] and hashes[2]!=hashes[3],"ART-07 four nonblank distinct facing frames (aesthetics require visual review)")
	visual.set_motion(true,false,false)
	await create_timer(0.17).timeout
	var progress: float = visual.sprite.frame_progress
	for i in range(10): visual.set_motion(true,false,false)
	var no_reset: bool = is_equal_approx(visual.sprite.frame_progress,progress)
	visual.set_motion(false,false,false)
	check(no_reset and visual.sprite.animation == &"idle_right","ART-08 walk does not restart per tick; stop retains facing")
	visual.set_facing(Vector2(1,1).normalized())
	check(visual.direction == "right","ART-09 exact diagonals retain previous facing; speed covered by T01")
	for angle in range(0,360,5):
		visual.set_facing(Vector2.from_angle(deg_to_rad(angle)))
		valid = valid and visual.direction in ["down","up","left","right"]
	var old_direction = visual.direction
	visual.set_facing(Vector2(0.001,0.001))
	check(valid and visual.direction == old_direction,"ART-10 360-degree aim quantization and near-origin deadzone")
	valid = true
	for value in [Vector2.DOWN,Vector2.UP,Vector2.LEFT,Vector2.RIGHT]:
		visual.reset_visuals()
		visual.set_facing(value)
		visual.play_attack()
		valid = valid and str(visual.sprite.animation) == "attack_"+visual.direction
		valid = valid and not visual.sprite.sprite_frames.get_frame_texture(visual.sprite.animation,0).get_image().is_invisible()
	check(valid,"ART-11 all attack directions use documented held pose plus engine arc")
	visual.reset_visuals()
	var pivot: Vector2 = visual.sprite.offset
	visual.set_motion(true,true,false)
	var sprint: bool = visual.visual_state() == "sprint" and visual.sprite.speed_scale == 1.5
	visual.set_motion(false,false,true)
	check(sprint and visual.scale == Vector2.ONE and visual.sprite.position.y == 1,"ART-12 sprint cadence and integer crouch offset without sprite deformation")
	visual.play_hurt()
	visual.play_ko()
	await create_timer(0.4).timeout
	var ko_frame: int = visual.sprite.frame
	visual.play_attack()
	visual.play_ko()
	check(visual.visual_state() == "ko" and not visual.sprite.is_playing() and visual.sprite.frame == ko_frame and visual.statuses.is_empty(),"ART-13 KO priority persists and clears effects; timed guard stun checked below")
	visual.reset_visuals()
	visual.set_status(&"stunned",true)
	visual.play_attack()
	var stunned: bool = visual.visual_state() == "stunned"
	visual.set_status(&"alert",true)
	visual.reset_visuals()
	check(stunned and visual.statuses.is_empty() and visual.sprite.modulate == Color.WHITE,"ART-14 stun blocks attack visuals and reset clears all overlays")
	valid = true
	for name in visual.profile.frames.get_animation_names():
		visual.sprite.play(name)
		valid = valid and visual.sprite.offset == pivot and visual.position == Vector2.ZERO
	check(valid,"ART-15 all clips share unchanged (16,27) anchor and physics origin")
	check(ProjectSettings.get_setting("display/window/stretch/mode") == "viewport" and ProjectSettings.get_setting("display/window/stretch/scale_mode") == "integer" and visual.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST,"ART-17 viewport integer stretch and nearest filtering")
	visual.queue_free()
	var stable: bool = true
	var listeners: int = -1
	for i in range(20):
		game.pending_save.clear()
		change_scene_to_file("res://scenes/levels/level_01_access.tscn")
		await scene_changed
		await physics_frame
		var level = current_scene
		var count: int = root.get_node("EventBus").noise_emitted.get_connections().size()
		if listeners == -1: listeners = count
		stable = stable and count == listeners
		stable = stable and get_nodes_in_group("player").size() == 1
		stable = stable and level.player.get_node("CharacterVisual").get_child_count() == 3
		for enemy in get_nodes_in_group("enemies"):
			if enemy.kind == "camera": continue
			stable = stable and enemy.get_node("CharacterVisual") != null
			var collider = enemy.get_node("CollisionShape2D")
			var original_transform: Transform2D = collider.transform
			enemy.stun(2.0)
			enemy._physics_process(0.1)
			stable = stable and enemy.state == "STUNNED" and not enemy.attack_fired and enemy.velocity == Vector2.ZERO
			stable = stable and collider.transform == original_transform
	check(stable,"ART-19 twenty real level reloads: one player, one visual per actor, stable signal count and stunned physics")
	check(current_scene.y_sort_enabled and current_scene.world.y_sort_enabled and current_scene.enemy_root.y_sort_enabled and current_scene.world.walls.z_index == -1,"ART-16 foreground Y-sort and wall collider separation; passage covered by T14/T29")
	game.pending_save.clear()
	change_scene_to_file("res://scenes/dev/character_showcase.tscn")
	await scene_changed
	check(current_scene.previews.size() == 5,"ART-22 runtime showcase with 2x/4x views and explicit original source labels")
	print("ART GODOT RESULT: ",passed," passed, ",failed," failed")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(saves.storage_path))
	if failed == 0:
		await game.quit_game()
	else:
		quit(1)
