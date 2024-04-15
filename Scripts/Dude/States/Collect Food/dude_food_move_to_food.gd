extends DudeFood
class_name DudeFoodMoveToFood

func Enter():
	super.Enter()
	
	dude_animator.play("move")

func Update(delta: float):
	super.Update(delta)

	move_towards_food(delta) 

func Physics_Update(delta: float):
	super.Physics_Update(delta)

	if food:
		var direction = (food.position - dude.position).normalized()
		dude.velocity = direction * move_speed
	else:
		dude.velocity = Vector2.ZERO

func move_towards_food(delta):
	if food:
		var distance = dude.position.distance_to(food.position)
		if distance <= collect_distance:
			Transitioned.emit(self, "CollectFood")
	else:
		Transitioned.emit(self, "IdleRoam")
