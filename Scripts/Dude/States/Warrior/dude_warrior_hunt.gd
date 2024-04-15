extends DudeWarrior
class_name DudeWarriorHunt

var target_position: Vector2

func Enter():
	super.Enter()
	dude_animator.play("warrior_move")


func Update(delta: float):
	super.Update(delta)
	
	if dude.target == null:
		Transitioned.emit(self, "WarriorRoam")
	else:
		if dude.position.distance_to(dude.target.position) < 50.0:
			Transitioned.emit(self, "WarriorAttack")
		

		

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	if dude and dude.target != null:
		var direction = (dude.target.position - dude.position).normalized()
		dude.velocity = direction * move_speed

