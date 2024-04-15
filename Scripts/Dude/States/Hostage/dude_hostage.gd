extends DudeState
class_name DudeHostage

func Enter():
	super.Enter()
	dude_animator.play("enemy_idle")
	
func Update(delta: float):
	super.Update(delta)
	#Need to make a check here for any enemy warriors, if none convert to idleroam state
	
func Physics_Update(delta: float):
	super.Physics_Update(delta)
