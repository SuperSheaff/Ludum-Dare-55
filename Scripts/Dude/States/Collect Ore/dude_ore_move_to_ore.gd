extends DudeOre
class_name DudeOreMoveToOre

func Enter():
	super.Enter()
	
	dude_animator.play("move")

func Update(delta: float):
	super.Update(delta)
	
	move_towards_ore(delta)

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	
	if ore:
		var direction = (ore.global_position - dude.global_position).normalized()
		dude.velocity = direction * move_speed
	else:
		dude.velocity = Vector2.ZERO

func move_towards_ore(delta):
	if ore:
		var distance = dude.global_position.distance_to(ore.global_position)
		if distance <= collect_distance:
			Transitioned.emit(self, "CollectOre")
	else:
		Transitioned.emit(self, "IdleRoam")
