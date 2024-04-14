extends Node2D

@onready var pause_menu = $Pause

func _ready():
	AudioManager.play_music("ambient", -6)


func _unhandled_input(event):
	if pause_menu.visible == false:
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_ESCAPE:
				pause_menu.make_visible()
				get_tree().paused = true
