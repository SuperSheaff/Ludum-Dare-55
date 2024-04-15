extends DudeState
class_name DudeHostage

var pause_time : float

func Enter():
	super.Enter()
	
	dude.is_hostage = true
	randomize_pause()
	dude_animator.play("enemy_idle")
	
func Exit():
	super.Exit()
	dude.is_hostage = false
	
func Update(delta: float):
	super.Update(delta)
	
	if has_parent_named(self, "Player"):
		Transitioned.emit(self, "IdleRoam")
	
func Physics_Update(delta: float):
	super.Physics_Update(delta)

func has_parent_named(node, name):
	while node:
		if node.name == name:
			return true
		node = node.get_parent()
	return false
	
func randomize_pause():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	pause_time = randf_range(0, 1)
	
