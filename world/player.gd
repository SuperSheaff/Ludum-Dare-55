extends Island

var direction = Vector2.ZERO

func _physics_process(delta):
	get_movement_direction()
	if direction != Vector2.ZERO:
		velocity = velocity.lerp(direction * 300, 0.5)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.1)

	move_and_slide()


func get_movement_direction():
	direction = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	direction = direction.normalized()
