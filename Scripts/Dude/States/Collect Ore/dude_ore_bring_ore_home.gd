extends DudeOre
class_name DudeOreBringOreHome

func Enter():
	super.Enter()
	
	dude_animator.play("move_ore")

func Update(delta: float):
	super.Update(delta)
	move_towards_house(delta)


func Physics_Update(delta: float):
	super.Physics_Update(delta)
	
	if house_position:
		var direction = (house_position - dude.global_position).normalized()
		dude.velocity = direction * move_speed
	else:
		dude.velocity = Vector2.ZERO

func move_towards_house(delta):
	if house_position:
		var distance = dude.global_position.distance_to(house_position)
		if distance <= house_distance:
			GameController.add_ore()
			Transitioned.emit(self, "MoveToOre")
	else:
		Transitioned.emit(self, "IdleRoam")
