extends SceneTree

# Original art: rows are authored here, never inferred from third-party geometry.
const DIRECTIONS := ["down", "up", "left", "right"]
const STATES := ["idle", "walk", "attack", "hurt", "ko", "crouch", "sprint", "interact", "stunned"]
const CAST := {
	"player_agent": ["54d8e8", "243e56"],
	"guard_standard": ["f4b860", "594c46"],
	"guard_alternate": ["f4b860", "4b4b6c"],
	"guard_heavy": ["f16d70", "524355"],
	"drone_security": ["b29bff", "354963"],
	"npc_scientist": ["47dbb4", "a9bcc8"]
}
var errors: int = 0

func _initialize() -> void:
	call_deferred("run")

func rect(image: Image, box: Rect2i, color: Color) -> void:
	image.fill_rect(box, color)

func body(actor: String, direction: String, frame: int, walking: bool) -> Image:
	var image := Image.create(32, 32, false, Image.FORMAT_RGBA8)
	var accent := Color(CAST[actor][0])
	var armor := Color(CAST[actor][1])
	var ink := Color("0a1220")
	var light := Color("dfe7f1")
	var heavy := actor == "guard_heavy"
	var side := direction in ["left", "right"]
	var step := (1 if frame % 4 == 1 else (-1 if frame % 4 == 3 else 0)) if walking else 0
	if actor == "drone_security":
		rect(image, Rect2i(3,12,26,10), ink)
		for x in [3,23]:
			rect(image, Rect2i(x,10,6,14), armor)
			rect(image, Rect2i(x+1,11,4,2), light)
			rect(image, Rect2i(x,17 + frame%2,6,2), accent)
		rect(image, Rect2i(10,9,12,16), ink)
		rect(image, Rect2i(11,10,10,13), armor.lightened(0.25))
		rect(image, Rect2i(13,13,6,6), accent.darkened(0.45))
		var eye := {"down":Rect2i(14,19,4,3),"up":Rect2i(14,10,4,3),"left":Rect2i(11,14,3,4),"right":Rect2i(18,14,3,4)}[direction] as Rect2i
		rect(image, eye, accent)
		rect(image, Rect2i(12,25,8,2), ink)
		return image
	var width := 18 if heavy else (12 if side else 14)
	var left := 16 - width / 2
	# Fixed boot baseline and independent alternating legs.
	for leg in range(2):
		var x := 11 + leg*6 if not side else 13 + leg*3
		var rise := maxi(0, step * (1 if leg == 0 else -1)) * 2
		rect(image, Rect2i(x,22,5,7-rise), ink)
		rect(image, Rect2i(x+1,22,3,4-rise), armor.darkened(0.2))
		rect(image, Rect2i(x,27-rise,5,2), Color("53657b"))
	rect(image, Rect2i(left-1,12,width+2,12), ink)
	rect(image, Rect2i(left,13,width,9), armor)
	rect(image, Rect2i(left+1,14,width-2,2), armor.lightened(0.22))
	rect(image, Rect2i(left+2,21,width-4,2), ink)
	rect(image, Rect2i(15,21,3,2), accent)
	for x in [left-3,left+width]:
		rect(image, Rect2i(x,14,3,9), ink)
		rect(image, Rect2i(x,15,3,5), armor.lightened(0.15))
		rect(image, Rect2i(x,20,3,2), Color("b98a78"))
	if heavy:
		for x in [left-3,left+width-1]:
			rect(image, Rect2i(x,12,4,6), Color("77849a"))
			rect(image, Rect2i(x,12,4,2), accent)
	elif actor == "npc_scientist":
		rect(image, Rect2i(left+1,15,width-2,7), light)
		rect(image, Rect2i(15,15,2,7), armor.darkened(0.3))
	else:
		rect(image, Rect2i(left+1,16,2,4), accent)
	# Helmet shape, back pack and directional visor; no runtime rotation/mirroring.
	rect(image, Rect2i(10,4,12,10), ink)
	rect(image, Rect2i(11,5,10,8), armor.lightened(0.2))
	rect(image, Rect2i(12,4,8,2), light.darkened(0.3) if heavy else armor.lightened(0.4))
	if direction == "up":
		rect(image, Rect2i(12,6,8,5), armor.darkened(0.2))
		rect(image, Rect2i(13,15,6,5), ink)
		rect(image, Rect2i(14,16,4,1), accent)
	elif side:
		var x := 10 if direction == "left" else 19
		rect(image, Rect2i(x,8,3,3), accent)
		rect(image, Rect2i(x,8,2,1), light)
	else:
		rect(image, Rect2i(11,8,10,4), ink)
		rect(image, Rect2i(12,8,8,2), accent)
		rect(image, Rect2i(13,8,3,1), light)
	if actor == "guard_alternate":
		rect(image, Rect2i(9,3,14,3), ink)
		rect(image, Rect2i(11,3,10,1), accent)
	if frame % 2 == 1 and not walking:
		rect(image, Rect2i(19,6,1,1), light)
	return image

func generate_images() -> void:
	DirAccess.make_dir_recursive_absolute("res://assets/characters/generated")
	for actor in CAST:
		var sheet := Image.create(128, 384, false, Image.FORMAT_RGBA8)
		for row in range(8):
			for col in range(4):
				var image := body(actor, DIRECTIONS[row % 4], col, row >= 4)
				sheet.blit_rect(image, Rect2i(0,0,32,32), Vector2i(col*32,row*32))
		for d in range(4):
			var fallen := Image.create(32,32,false,Image.FORMAT_RGBA8)
			rect(fallen,Rect2i(3,20,26,8),Color("0a1220"))
			rect(fallen,Rect2i(5,21,7,6),Color(CAST[actor][1]).lightened(0.2))
			rect(fallen,Rect2i(13,22,9,5),Color(CAST[actor][1]))
			rect(fallen,Rect2i(23,23,6,3),Color("53657b"))
			rect(fallen,Rect2i(5 if d in [0,2] else 10,22,2,3),Color(CAST[actor][0]))
			sheet.blit_rect(fallen,Rect2i(0,0,32,32),Vector2i(0,(8+d)*32))
		var result := sheet.save_png("res://assets/characters/generated/%s.png" % actor)
		if result != OK:
			push_error("Could not save original sheet: " + actor)
			errors += 1
	print("Original character PNGs: ", CAST.size())

func run() -> void:
	if "--images" in OS.get_cmdline_user_args():
		generate_images()
		quit(errors)
		return
	var roster = JSON.parse_string(FileAccess.get_file_as_string("res://config/character_roster.json"))
	if not roster is Dictionary or roster.get("schema_version") != 2:
		push_error("Invalid character roster")
		quit(1)
		return
	var registry = JSON.parse_string(FileAccess.get_file_as_string("res://config/asset_pack_registry.json"))
	var matrix := FileAccess.open("res://docs/CHARACTER_ANIMATION_MATRIX.csv", FileAccess.WRITE)
	matrix.store_csv_line(PackedStringArray(["actor_key","semantic_animation","source_pack","source_png","source_region_px","source_frame_indices","duration_or_fps","loop","pivot_px","flip_h","provenance","verified_preview"]))
	for actor in roster.characters:
		var record: Dictionary = roster.characters[actor]
		var destination: String = record.get("runtime_resource", "")
		if not destination.begins_with("res://resources/characters/") or ".." in destination or not destination.ends_with(".tres"):
			push_error("Unsafe profile destination: " + destination)
			errors += 1
			continue
		if record.get("source_pack", "original") != "original":
			var pack: Dictionary = registry.get("packs",{}).get(record.source_pack,{})
			if not pack.get("license_verified",false) or not pack.get("raw_redistribution_allowed",false) or pack.get("evidence",[]).is_empty():
				push_error("Unverified source pack: " + record.source_pack)
				errors += 1
				continue
		var actor_error_start: int = errors
		var frames := SpriteFrames.new()
		frames.remove_animation("default")
		for state in STATES:
			for d in range(4):
				var clip: String = state + "_" + DIRECTIONS[d]
				var row: int = d + (8 if state == "ko" else (4 if state in ["walk","sprint"] else 0))
				var count: int = 4 if state in ["walk","sprint"] else (2 if state == "idle" else 1)
				var fps: float = 8.0 if state in ["walk","sprint"] else 4.0
				var looping: bool = state not in ["attack","hurt","ko"]
				var path: String = record.source_png
				var regions: Array = []
				for i in range(count): regions.append([i*32,row*32,32,32])
				var provenance := "generated" if state in ["idle","walk","sprint","ko"] else "sibling+fx"
				# External sheets require exact reviewed semantic regions; no geometry guessing.
				if record.get("source_pack", "original") != "original":
					var mapping: Dictionary = record.get("animations", {}).get(clip, {})
					if mapping.is_empty() or not record.get("reviewed", false):
						push_error("Missing reviewed clip: " + actor + "/" + clip)
						errors += 1
						continue
					path = mapping.texture
					regions = mapping.regions
					fps = float(mapping.fps)
					provenance = mapping.provenance
				if not path.begins_with("res://assets/") or ".." in path or not path.ends_with(".png"):
					push_error("Unsafe texture path: " + path)
					errors += 1
					continue
				var texture := load(path) as Texture2D
				if texture == null or fps <= 0 or fps > 60 or regions.is_empty():
					push_error("Invalid animation data: " + clip)
					errors += 1
					continue
				frames.add_animation(clip)
				frames.set_animation_speed(clip, fps)
				frames.set_animation_loop(clip, looping)
				for box in regions:
					if not box is Array or box.size() != 4:
						push_error("Malformed source region: " + clip)
						errors += 1
						continue
					var area := Rect2(box[0],box[1],box[2],box[3])
					if area.size.x <= 0 or area.size.y <= 0 or not Rect2(Vector2.ZERO,texture.get_size()).encloses(area):
						push_error("Out-of-bounds region: " + clip)
						errors += 1
						continue
					var frame := AtlasTexture.new()
					frame.atlas = texture
					frame.region = area
					frames.add_frame(clip, frame)
				matrix.store_csv_line(PackedStringArray([actor,clip,record.get("source_pack","original"),path,JSON.stringify(regions),"explicit regions",str(fps),str(looping),"16,27","false",provenance,"runtime review required"]))
		if errors > actor_error_start:
			push_warning("Rejected incomplete actor; existing resources retained: " + actor)
			continue
		var frame_path := "res://resources/characters/%s_frames.tres" % actor
		if ResourceSaver.save(frames,frame_path) != OK: errors += 1
		canonicalize(frame_path)
		var profile = load("res://resources/character_visual_profile.gd").new()
		profile.actor_key = StringName(actor)
		profile.frames = load(frame_path)
		profile.accent = Color(record.accent)
		profile.source_pack = record.get("source_pack","original")
		if ResourceSaver.save(profile,record.runtime_resource) != OK: errors += 1
		canonicalize(record.runtime_resource)
	matrix.close()
	print("SpriteFrames built: ",roster.characters.size(),"; errors: ",errors)
	quit(1 if errors else 0)

func canonicalize(path: String) -> void:
	# ResourceSaver assigns random text IDs. Stable names keep rebuilds diff-free.
	var text := FileAccess.get_file_as_string(path)
	var regex := RegEx.new()
	regex.compile('id="([^"]+)"')
	var ids: Dictionary = {}
	for result in regex.search_all(text):
		var old: String = result.get_string(1)
		if not ids.has(old): ids[old] = "resource_%03d" % ids.size()
	for old in ids:
		text = text.replace('"' + old + '"', '"' + ids[old] + '"')
	regex.compile(' uid="[^"]+"')
	text = regex.sub(text,"",true)
	var file := FileAccess.open(path,FileAccess.WRITE)
	file.store_string(text)
	file.close()
