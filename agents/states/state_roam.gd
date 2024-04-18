class_name StateRoam
extends State


func enter_state():
	if not _entity.world:	# Just so you can run worker scene by itself
		_fsm.set_state("StateIdle")
		return
		
	_entity.anim_player.play("walk")
	_entity.set_target(_entity.world.get_random_target())
	
	
	
func process(delta):
	if _entity.navigation_finished:
		_fsm.set_state("StateIdle")
	
	
func exit_state():
	pass

