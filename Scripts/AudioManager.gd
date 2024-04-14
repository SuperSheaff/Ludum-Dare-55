extends Node

var audio_files = \
{
	"food" : ["res://Audio/food.wav", "SFX", 0],
	"ore" : ["res://Audio/ore.wav", "SFX", 0],
	"deposit" : ["res://Audio/deposit.wav", "SFX", 0],
	"spawn" : ["res://Audio/spawn.wav", "SFX", 0],
	#Music
	"ambient" : ["res://Audio/awful_music.ogg", "MUSIC", 1]

}

signal sound_complete(sound_name)

var audio_streams = {}
var audio_buses = {}
var audio_stream_players = {}
var time_last_played = {}


var music_streams = []

var current_music = null
var current_music_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_audio() # probs change 	

		
func load_audio():
	for key in audio_files:
		var stream = load(audio_files[key][0])
		if audio_files[key][0].get_extension() == 'ogg':
			stream.set_loop(audio_files[key][2])
		else:
			stream.set_loop_mode(audio_files[key][2])
			
		audio_streams[key] = stream 
		audio_buses[key] = audio_files[key][1]
		time_last_played[key] = 0


func play(sound_name, volume = -3, pitch = 1.0, fade = 0, music=false):
	if !audio_streams.has(sound_name):
		print("Cannot find sound %s" % sound_name)
		return null
		
	var stream_player = AudioStreamPlayer.new()
	stream_player.finished.connect(_on_sound_finished.bind(stream_player, music))
	stream_player.set_stream(audio_streams[sound_name])
	stream_player.set_bus(audio_buses[sound_name])
	stream_player.set_pitch_scale(pitch)
	stream_player.set_volume_db(volume)
	add_sound(stream_player)
	
	if fade != 0:
		stream_player.volume_db = -80
		var t = get_tree().create_tween()
		t.tween_property(stream_player, "volume_db", volume, fade)
		t.tween_callback(Callable(self, "_on_fade_finished"))
	
	stream_player.play()
	time_last_played[sound_name] = Time.get_ticks_msec()
	return stream_player


func play_music(sound_name, volume = -3, pitch = 1.0, fade = 0):
	for m in music_streams:
		m.queue_free()
	music_streams = []
		
	current_music = play(sound_name, volume, pitch, fade, true)
	current_music_name = sound_name
	music_streams.append(current_music)
	print("PLAY MUSIC: %s" % str(current_music))
	
	
func stop_music(_sound_name, fade):
#	print("STOP MUSIC: %s" % str(current_music))
	if current_music != null:
		if fade != 0:
			var t = get_tree().create_tween()
			t.tween_property(current_music, "volume_db", -80, fade)
#			var cal = Callable(self, "_on_music_fade_finished")
			t.tween_callback(func() : self._on_music_fade_finished())
			

func get_music_pos():
	if current_music != null:
		return current_music.get_playback_position()


func stop(_sound_name, _fade=0):
	pass

func add_sound(sound):
	add_child(sound)
	
func remove_sound(sound):
	sound.queue_free()
	remove_child(sound)

func get_time_last_played(sound_name):
	return time_last_played[sound_name]

func get_num_playing(sound_name):
	var count = 0
	for s in get_children():
		if s.stream == audio_streams[sound_name]:
			count += 1
	return count

func _on_sound_finished(sound, music):
	if music:
		current_music = null
		current_music_name = ""
		music_streams = []
	remove_sound(sound)
	emit_signal("sound_complete")
	
func _on_fade_finished(_object, _path, fade):
	fade.queue_free()
	remove_child(fade)
	
	
func _on_music_fade_finished():
#	print("MUSIC FADE FINISHED")
	current_music = null
