class_name GameHUD
extends CanvasLayer

var level: Node2D
var health_bar: ProgressBar
var stamina_bar: ProgressBar
var objective: Label
var alarm: Label
var inventory: Label
var prompt: Label
var toast: Label
var toast_time: float = 0.0
var modal: PanelContainer
var debug_text: Label
var minimap: Control
var guidance: Label
var combat_taught: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = UIStyle.theme()
	add_child(root)
	var top := ColorRect.new()
	top.color = Color(0.035,0.07,0.11,0.94)
	top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top.offset_bottom = 53
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(top)
	var left := VBoxContainer.new()
	left.position = Vector2(15, 7)
	left.add_theme_constant_override("separation", 3)
	root.add_child(left)
	left.add_child(UIStyle.label("GHOST / FIELD OPERATIVE", 9, UIStyle.CYAN))
	health_bar = bar(left, UIStyle.CYAN)
	stamina_bar = bar(left, Color("96a8b8"))
	var right := VBoxContainer.new()
	right.position = Vector2(230, 7)
	root.add_child(right)
	right.add_child(UIStyle.label(level.definition.subtitle + "   /   " + level.definition.title, 10, UIStyle.MUTED))
	objective = UIStyle.label("", 12)
	right.add_child(objective)
	alarm = UIStyle.label("", 10)
	alarm.position = Vector2(505, 39)
	root.add_child(alarm)
	inventory = UIStyle.label("", 10, UIStyle.CYAN)
	inventory.position = Vector2(15, 337)
	root.add_child(inventory)
	guidance = UIStyle.label("", 10, UIStyle.MUTED)
	guidance.position = Vector2(15, 320)
	root.add_child(guidance)
	prompt = UIStyle.label("", 12)
	prompt.position = Vector2(225, 311)
	root.add_child(prompt)
	toast = UIStyle.label("", 11, Color("ffb454"))
	toast.position = Vector2(175, 65)
	root.add_child(toast)
	debug_text = UIStyle.label("", 9, UIStyle.CYAN)
	debug_text.position = Vector2(12, 65)
	root.add_child(debug_text)
	EventBus.notification.connect(notify)
	minimap = Control.new()
	minimap.position = Vector2(518, 264)
	minimap.size = Vector2(108, 66)
	minimap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(minimap)
	minimap.draw.connect(draw_minimap)
	if level.level_id == 0:
		notify("WASD move · SHIFT sprint · CTRL crouch · E interact")

func bar(parent: Node, color: Color) -> ProgressBar:
	var node := ProgressBar.new()
	node.custom_minimum_size = Vector2(175, 6)
	node.show_percentage = false
	var style := UIStyle.panel(color)
	style.set_content_margin_all(0)
	node.add_theme_stylebox_override("fill", style)
	var background := UIStyle.panel(Color("0b1421"))
	background.set_content_margin_all(0)
	node.add_theme_stylebox_override("background", background)
	parent.add_child(node)
	return node

func notify(message: String) -> void:
	toast.text = message
	toast_time = 4.5

func _process(delta: float) -> void:
	if not is_instance_valid(level.player):
		return
	var player: PlayerController = level.player
	minimap.queue_redraw()
	health_bar.value = player.health.current
	stamina_bar.value = player.stamina.current
	objective.text = "›  " + level.mission.next_title()
	var next_item: WorldItem = null
	for item in level.objects:
		if item.used:
			continue
		if level.mission.can_complete(item.objective) or (level.mission.all_complete() and item.kind == "extraction"):
			next_item = item
			break
	if is_instance_valid(next_item):
		var offset := next_item.position - player.position
		var bearing := ("N" if offset.y < -24 else ("S" if offset.y > 24 else "")) + ("E" if offset.x > 24 else ("W" if offset.x < -24 else ""))
		guidance.text = "OBJECTIVE / " + (bearing if bearing != "" else "NEARBY") + "    ESC PAUSE" + (" · F3 DEBUG" if OS.is_debug_build() else "")
	if level.level_id == 0 and not combat_taught and not get_tree().paused:
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if enemy.position.distance_to(player.position) < 150:
				combat_taught = true
				notify("CTRL reduces visibility · Click stuns · Q emits EMP")
				break
	alarm.text = level.alarm_name()
	alarm.modulate = UIStyle.RED if level.alarm_value >= 50 else UIStyle.CYAN
	inventory.text = "HP %03d   ST %03d   /   Q EMP %d   /   CARDS %s" % [player.health.current, player.stamina.current, player.inventory.emp_charges, ", ".join(player.inventory.keycards).to_upper()]
	var target: WorldItem = level.nearest_interactable()
	prompt.text = "E  /  " + target.get_interaction_label() if is_instance_valid(target) and not player.health.dead else ""
	if not get_tree().paused:
		toast_time -= delta
	toast.visible = toast_time > 0.0
	debug_text.visible = GameManager.debug_enabled and OS.is_debug_build()
	if debug_text.visible:
		debug_text.text = level.debug_summary()
	if Input.is_action_just_pressed("pause") and not player.health.dead:
		if is_instance_valid(modal):
			close_modal()
		else:
			show_pause()
	if player.health.dead and Input.is_action_just_pressed("reload_checkpoint"):
		level.retry()

func draw_minimap() -> void:
	minimap.draw_rect(Rect2(Vector2.ZERO, minimap.size), Color(0.035,0.07,0.11,0.9))
	var scale_factor: float = minf(104.0 / level.world.grid_size.x, 62.0 / level.world.grid_size.y)
	for cell in level.world.solid_cells:
		minimap.draw_rect(Rect2(Vector2(cell) * scale_factor + Vector2(2,2), Vector2.ONE * scale_factor), Color("3c5365"))
	for item in level.objects:
		if not item.used and item.kind != "door":
			minimap.draw_circle(item.position / 32.0 * scale_factor + Vector2(2,2), 1.5, UIStyle.CYAN)
	minimap.draw_circle(level.player.position / 32.0 * scale_factor + Vector2(2,2), 2.0, Color.WHITE)

func close_modal() -> void:
	if is_instance_valid(modal):
		modal.queue_free()
		modal = null
	get_tree().paused = false

func modal_box(title: String) -> VBoxContainer:
	if is_instance_valid(modal):
		modal.queue_free()
	get_tree().paused = true
	modal = PanelContainer.new()
	modal.theme = UIStyle.theme()
	modal.position = Vector2(192, 78)
	modal.custom_minimum_size = Vector2(255, 190)
	add_child(modal)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	modal.add_child(box)
	box.add_child(UIStyle.label(title, 23, UIStyle.CYAN))
	return box

func show_pause() -> void:
	var box := modal_box("SIGNAL PAUSED")
	var resume := UIStyle.button("RESUME", close_modal)
	box.add_child(resume)
	box.add_child(UIStyle.button("RETRY CHECKPOINT", level.retry))
	box.add_child(UIStyle.button("SETTINGS", show_settings))
	box.add_child(UIStyle.button("MAIN MENU", GameManager.menu))
	resume.grab_focus()

func show_settings() -> void:
	var box := modal_box("SETTINGS")
	SettingsPanel.populate(box)
	var back := UIStyle.button("BACK", show_pause)
	box.add_child(back)
	back.grab_focus()

func show_death() -> void:
	var box := modal_box("SIGNAL LOST")
	box.add_child(UIStyle.label("Operative down. R retries checkpoint.", 11))
	var retry := UIStyle.button("RETRY CHECKPOINT", level.retry)
	box.add_child(retry)
	box.add_child(UIStyle.button("MAIN MENU", GameManager.menu))
	retry.grab_focus()
