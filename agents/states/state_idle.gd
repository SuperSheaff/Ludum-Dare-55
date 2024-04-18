class_name StateIdle
extends State

@onready var _timer = get_node("Timer")


func enter_state():
	_entity.anim_player.play("idle")
	_timer.wait_time = randf_range(0.5, 1.5)
	_timer.start()


func process(delta):
	pass
	
	
func exit_state():
	pass
	

func _on_timer_timeout():
	_fsm.set_state("StateRoam")
