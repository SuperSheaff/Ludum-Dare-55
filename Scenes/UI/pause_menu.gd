extends Control

var can_be_closed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func make_visible():
	$Timer.start()
	show()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_be_closed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().paused = false
			hide()
			can_be_closed = false
			pass

#func _unhandled_input(event):
	#print("asda")
	#if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_ESCAPE:
			#hide()
			#get_tree().paused = false
			

func _on_music_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("MUSIC")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_timer_timeout():
	can_be_closed = true
	pass # Replace with function body.


