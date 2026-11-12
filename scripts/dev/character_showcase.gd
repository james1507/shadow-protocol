extends Node2D

const KEYS := ["player_agent","guard_standard","guard_alternate","guard_heavy","drone_security","npc_scientist"]
const STATES := ["idle","walk","attack","hurt","ko","crouch","sprint","interact","stunned"]
const DIRECTIONS := [Vector2.DOWN,Vector2.UP,Vector2.LEFT,Vector2.RIGHT]
var previews: Array[CharacterVisual] = []
var actor_picker: OptionButton
var state_picker: OptionButton
var playing: bool = true
var label: Label

func text(value: String, at: Vector2, font_size: int = 11, color := Color("dfe7f1")) -> Label:
	var result := UIStyle.label(value, font_size, color)
	result.position = at
	add_child(result)
	return result

func _ready() -> void:
	text("CHARACTER LAB",Vector2(20,12),22)
	text("V2 / ORIGINAL_FALLBACK / 32 px / MIT original art",Vector2(20,39),10,Color("54d8e8"))
	actor_picker = OptionButton.new()
	actor_picker.position = Vector2(20,59)
	actor_picker.size = Vector2(190,28)
	for key in KEYS: actor_picker.add_item(key)
	add_child(actor_picker)
	state_picker = OptionButton.new()
	state_picker.position = Vector2(220,59)
	state_picker.size = Vector2(110,28)
	for state in STATES: state_picker.add_item(state)
	add_child(state_picker)
	var toggle := UIStyle.button("PAUSE",func():
		playing = not playing
		for visual in previews: visual.sprite.set_process(playing))
	toggle.custom_minimum_size = Vector2(80,28)
	toggle.position = Vector2(340,59)
	toggle.size = Vector2(80,28)
	add_child(toggle)
	var back := UIStyle.button("MENU",func(): get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn"))
	back.custom_minimum_size = Vector2(85,28)
	back.position = Vector2(535,22)
	back.size = Vector2(85,28)
	add_child(back)
	for i in range(5):
		var visual: CharacterVisual = preload("res://scenes/characters/character_visual.tscn").instantiate()
		visual.position = Vector2(68+i*106,208) if i < 4 else Vector2(548,229)
		add_child(visual)
		visual.scale = Vector2.ONE * (2 if i < 4 else 4)
		visual.set_facing(DIRECTIONS[i] if i < 4 else Vector2.RIGHT)
		previews.append(visual)
		text("+",visual.position+Vector2(-3,2),10,Color("47dbb4"))
		text(["DOWN 2x","UP 2x","LEFT 2x","RIGHT 2x","DETAIL 4x"][i],Vector2(visual.position.x-30,244),10)
	for i in range(KEYS.size()):
		var visual: CharacterVisual = preload("res://scenes/characters/character_visual.tscn").instantiate()
		visual.actor_key = KEYS[i]
		visual.position = Vector2(65+i*102,313)
		add_child(visual)
		text(KEYS[i].replace("guard_","g_").replace("drone_security","drone").replace("npc_scientist","scientist").replace("player_agent","agent"),Vector2(visual.position.x-32,321),9)
	label = text("",Vector2(20,94),10,Color("96a8b8"))
	text("Crosshair = physics / feet anchor (16,27).  Tab + arrows / mouse: selectors.",Vector2(20,345),10,Color("96a8b8"))
	actor_picker.item_selected.connect(func(_i: int): refresh())
	state_picker.item_selected.connect(func(_i: int): refresh())
	actor_picker.grab_focus()
	refresh()

func refresh() -> void:
	for visual in previews:
		visual.set_profile(CharacterVisualRegistry.resolve(KEYS[actor_picker.selected]))
		visual.scale = Vector2.ONE * (4 if visual == previews[-1] else 2)
		var state: String = STATES[state_picker.selected]
		match state:
			"walk", "sprint", "crouch": visual.set_motion(state != "crouch",state == "sprint",state == "crouch")
			"attack": visual.play_attack()
			"hurt": visual.play_hurt()
			"ko": visual.play_ko()
			"interact", "stunned": visual.set_status(StringName(state),true)
	label.text = "%s / %s / fixed body collider / pixel scale 1x in game" % [KEYS[actor_picker.selected],STATES[state_picker.selected]]
	queue_redraw()

func _process(_delta: float) -> void:
	for visual in previews:
		visual.set_process(playing)
		visual.sprite.speed_scale = 0.0 if not playing else (1.5 if visual.sprinting else 1.0)
		# Replay short actions in the lab only; gameplay owns its own action timing.
		if playing and STATES[state_picker.selected] in ["attack","hurt"] and visual.action == "":
			visual.play_attack() if state_picker.selected == 2 else visual.play_hurt()

func _draw() -> void:
	draw_rect(Rect2(0,0,640,360),Color("0d1524"))
	for i in range(5):
		var at := Vector2(68+i*106,208) if i < 4 else Vector2(548,229)
		draw_rect(Rect2(at+Vector2(-45,-95 if i<4 else -125),Vector2(90,120 if i<4 else 150)),Color("172338"))
		draw_line(at-Vector2(8,0),at+Vector2(8,0),Color("47dbb4"))
		draw_line(at-Vector2(0,5),at+Vector2(0,5),Color("47dbb4"))
