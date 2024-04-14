extends Node2D

@onready var pause_menu = $Pause

func _process(delta):
	#if Input.is_action_just_pressed("ui_cancel"):
		#
		#pause_menu.show()
		#get_tree().paused = true
		#pass
	pass


func _unhandled_input(event):
	if pause_menu.visible == false:
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_ESCAPE:
				pause_menu.make_visible()
				get_tree().paused = true
