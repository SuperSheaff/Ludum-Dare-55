extends DudeFood
class_name DudeFoodBringFoodHome

func Enter():
	super.Enter()
	
	dude_animator.play("move_food")  # Assuming there's a walking animation

func Update(delta: float):
	super.Update(delta)
	move_towards_house(delta)  # Handle movement towards the house


func Physics_Update(delta: float):
	super.Physics_Update(delta)
	# Handle physical movement towards the house
	if house_position:
		var direction = (house_position - dude.global_position).normalized()
		dude.velocity = direction * move_speed
	else:
		dude.velocity = Vector2.ZERO

func move_towards_house(delta):
	if house_position:
		var distance = dude.global_position.distance_to(house_position)
		if distance <= house_distance:
			GameController.add_food()
			Transitioned.emit(self, "MoveToFood")  # Change to the state to move towards food again
	else:
		Transitioned.emit(self, "IdleRoam")  # No house found, return to idle or some other state
