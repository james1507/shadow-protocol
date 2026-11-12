class_name CharacterVisualRegistry
extends RefCounted

static var profiles: Dictionary = {}

static func resolve(actor_key: StringName) -> CharacterVisualProfile:
	if profiles.has(actor_key):
		return profiles[actor_key]
	var roster = JSON.parse_string(FileAccess.get_file_as_string("res://config/character_roster.json"))
	var path: String = "res://resources/characters/player_agent.tres"
	if roster is Dictionary:
		path = roster.get("characters", {}).get(str(actor_key), {}).get("runtime_resource", path)
	var profile := load(path) as CharacterVisualProfile
	if profile == null or profile.frames == null:
		push_warning("Invalid visual profile: " + path + "; using original player")
		profile = load("res://resources/characters/player_agent.tres") as CharacterVisualProfile
	profiles[actor_key] = profile
	return profile
