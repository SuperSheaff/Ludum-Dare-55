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
		var direction = (house_position - dude.position).normalized()
		dude.velocity = direction * move_speed
	else:
		dude.velocity = Vector2.ZERO

func move_towards_house(delta):
	if house_position:
		var distance = dude.position.distance_to(house_position)
		if distance <= house_distance:
			GameData.add_ore()
			AudioManager.play("deposit", -14)
			Transitioned.emit(self, "MoveToOre")
	else:
		Transitioned.emit(self, "IdleRoam")
