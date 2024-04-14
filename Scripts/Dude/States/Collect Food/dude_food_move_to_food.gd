extends DudeFood
class_name DudeFoodMoveToFood

func Enter():
	super.Enter()
	
	dude_animator.play("move")  # Assuming there's a walking animation

func Update(delta: float):
	super.Update(delta)
	
	# Remove pause related logic if not necessary
	move_towards_food(delta)  # Handle movement towards the food

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	# Handle physical movement towards the target food
	if food:
		var direction = (food.global_position - dude.global_position).normalized()
		dude.velocity = direction * move_speed
	else:
		dude.velocity = Vector2.ZERO

func move_towards_food(delta):
	if food:
		var distance = dude.global_position.distance_to(food.global_position)
		if distance <= collect_distance:
			Transitioned.emit(self, "CollectFood")  # Change to the appropriate state to collect food
	else:
		Transitioned.emit(self, "IdleRoam")  # No food found, return to idle or some other state
