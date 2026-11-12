class_name AssetLibrary
extends RefCounted

static var cache: Dictionary = {}

static func texture(usage: String) -> Texture2D:
	if cache.has(usage):
		return cache[usage]
	cache[usage] = null
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://config/asset_mapping.json"))
	if not parsed is Dictionary or not parsed.get("assets") is Array:
		return null
	for entry in parsed.assets:
		if not entry is Dictionary or entry.get("usage") != usage or entry.get("reviewed") != true or entry.get("license_id") != "CC0-1.0":
			continue
		var destination: String = entry.get("destination", "")
		if destination.is_absolute_path() or ".." in destination.split("/") or destination.get_extension().to_lower() not in ["png", "svg", "webp"]:
			continue
		var path := "res://assets/" + destination
		if not FileAccess.file_exists(path) or FileAccess.get_sha256(path) != entry.get("sha256") or not ResourceLoader.exists(path):
			continue
		var loaded: Variant = load(path)
		if not loaded is Texture2D:
			continue
		if entry.has("frame_width") and entry.has("frame_height"):
			var frame := Vector2(float(entry.frame_width), float(entry.frame_height))
			if frame.x <= 0 or frame.y <= 0 or frame.x > loaded.get_width() or frame.y > loaded.get_height():
				continue
			var atlas := AtlasTexture.new()
			atlas.atlas = loaded
			atlas.region = Rect2(Vector2.ZERO, frame)
			loaded = atlas
		cache[usage] = loaded
		return loaded
	return null
