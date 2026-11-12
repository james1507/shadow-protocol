extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game = root.get_node("GameManager")
	game.debug_enabled = false
	root.get_node("SaveManager").storage_path = "user://benchmark-only.json"
	change_scene_to_file("res://scenes/levels/test_arena.tscn")
	await scene_changed
	var level = current_scene
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	var output: Array = []
	for count in [10,20,40]:
		for enemy in level.enemy_root.get_children():
			enemy.queue_free()
		await process_frame
		for i in range(count):
			var enemy = load("res://scenes/enemies/guard.tscn").instantiate()
			enemy.level = level
			enemy.position = level.world.center(Vector2i(16+i%10,3+int(i/10)*3))
			enemy.patrol.append(enemy.position)
			enemy.patrol.append(enemy.position+Vector2(0,64))
			level.enemy_root.add_child(enemy)
		await create_timer(1.0).timeout
		var samples: Array[float] = []
		var start := Time.get_ticks_usec()
		var previous := start
		while Time.get_ticks_usec() - start < 3000000:
			await process_frame
			var now := Time.get_ticks_usec()
			samples.append(float(now-previous)/1000.0)
			previous = now
		samples.sort()
		var average: float = 0.0
		for sample in samples:
			average += sample
		average /= samples.size()
		var result := {"agents":count,"frames":samples.size(),"mean_ms":average,"p95_ms":samples[int(samples.size()*0.95)],"max_ms":samples[-1],"fps":1000.0/average}
		output.append(result)
		print("BENCHMARK ",JSON.stringify(result))
	var file := FileAccess.open("res://docs/benchmark.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"renderer":RenderingServer.get_video_adapter_name(),"os":OS.get_name(),"resolution":[1280,720],"debug_overlay":false,"vsync":true,"samples":output},"  "))
	file.close()
	quit()
