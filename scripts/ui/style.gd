class_name UIStyle
extends RefCounted

const CYAN := Color("43d9e8")
const MUTED := Color("96a8b8")
const TEXT := Color("e7f0f5")
const RED := Color("f56b73")

static func panel(color: Color = Color("162635")) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = Color("304859")
	box.set_border_width_all(1)
	box.set_content_margin_all(10)
	box.set_corner_radius_all(3)
	return box

static func theme() -> Theme:
	var t := Theme.new()
	t.default_font_size = 12
	t.set_color("font_color", "Label", TEXT)
	t.set_stylebox("panel", "PanelContainer", panel())
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		var box := panel(Color("18323f") if state in ["hover", "focus"] else Color("112331"))
		box.content_margin_top = 5
		box.content_margin_bottom = 5
		if state == "focus":
			box.border_color = CYAN
		t.set_stylebox(state, "Button", box)
	t.set_color("font_color", "Button", TEXT)
	t.set_color("font_disabled_color", "Button", Color("506477"))
	t.set_stylebox("background", "ProgressBar", panel(Color("0b1421")))
	var fill := panel(CYAN)
	fill.set_border_width_all(0)
	t.set_stylebox("fill", "ProgressBar", fill)
	return t

static func label(text: String, size: int = 12, color: Color = TEXT) -> Label:
	var node := Label.new()
	node.text = text
	node.add_theme_font_size_override("font_size", size)
	node.add_theme_color_override("font_color", color)
	return node

static func button(text: String, callback: Callable) -> Button:
	var node := Button.new()
	node.text = text
	node.custom_minimum_size = Vector2(200, 29)
	node.alignment = HORIZONTAL_ALIGNMENT_LEFT
	node.pressed.connect(func():
		AudioManager.play_sfx("button")
		callback.call())
	return node
