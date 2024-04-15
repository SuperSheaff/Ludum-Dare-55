extends DudeState
class_name DudeHostage

func Enter():
	super.Enter()
	dude_animator.play("enemy_idle")
	
func Update(delta: float):
	super.Update(delta)
	
	if has_parent_named(self, "Player"):
		Transitioned.emit(self, "IdleRoam")
	else:
		print("not")
	#Need to make a check here for any enemy warriors, if none convert to idleroam state
	
func Physics_Update(delta: float):
	super.Physics_Update(delta)

func has_parent_named(node, name):
	while node:
		if node.name == name:
			return true
		node = node.get_parent()
	return false
	
