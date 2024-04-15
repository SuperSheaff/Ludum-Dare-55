extends DudeWarrior
class_name DudeWarriorAttack

var target_position: Vector2
var current_time = 0

func Enter():
	super.Enter()
	dude_animator.play("warrior_attack")
	current_time = 0

func Update(delta: float):
	super.Update(delta)
	
	if dude.target == null:
		Transitioned.emit(self, "WarriorRoam")
	else:
		if dude.position.distance_to(dude.target.position) > 100.0:
			Transitioned.emit(self, "WarriorHunt")
			
		if current_time >= 1:
			dude.target.hit()
			current_time = 0
			
	current_time += delta

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	if dude:
		dude.velocity = Vector2.ZERO

