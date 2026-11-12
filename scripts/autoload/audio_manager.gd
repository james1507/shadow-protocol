extends Node

var tones: Dictionary = {}
var last_played: Dictionary = {}

func _ready() -> void:
	for bus in ["Music", "SFX"]:
		if AudioServer.get_bus_index(bus) < 0:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.bus_count - 1, bus)
	var frequencies := {"pickup": 880.0, "terminal": 330.0, "door": 160.0, "stun": 220.0, "emp": 90.0, "hit": 110.0, "alarm": 660.0, "success": 1046.5, "button": 520.0, "step": 65.0}
	for key in frequencies:
		var sound := AudioStreamWAV.new()
		sound.format = AudioStreamWAV.FORMAT_16_BITS
		sound.mix_rate = 22050
		var pcm := PackedByteArray()
		var frames: int = 3307
		pcm.resize(frames * 2)
		for i in range(frames):
			var envelope: float = pow(1.0 - float(i) / frames, 3.0)
			var value: int = int(sin(float(i) / 22050.0 * TAU * frequencies[key]) * envelope * 9000)
			pcm.encode_s16(i * 2, value)
		sound.data = pcm
		tones[key] = sound

func play_sfx(key: String) -> void:
	if not tones.has(key) or DisplayServer.get_name() == "headless":
		return
	var now := Time.get_ticks_msec()
	if now - int(last_played.get(key, -1000)) < 90:
		return
	last_played[key] = now
	var source := AudioStreamPlayer.new()
	source.bus = "SFX"
	source.stream = tones[key]
	add_child(source)
	source.finished.connect(source.queue_free)
	source.play()

func stop_all() -> void:
	for source in get_children():
		if source is AudioStreamPlayer:
			source.stop()
			source.stream = null

func _exit_tree() -> void:
	stop_all()
	tones.clear()
