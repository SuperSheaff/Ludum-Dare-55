extends DudeIdle
class_name DudeIdleRoam

var wander_time : float

func Enter():
	super.Enter()
	
	randomize_wander()
	dude_animator.play("move")
	
func Update(delta: float):
	super.Update(delta)

	if wander_time > 0:
		wander_time -= delta
		
	else:
		Transitioned.emit(self, "IdlePause")

func Physics_Update(delta: float):
	super.Physics_Update(delta)
		
	if dude:
		dude.velocity = move_direction * move_speed
		
		var motion = dude.velocity * delta
		var new_position = dude.global_position + motion
		if is_within_tilemap_bounds(new_position):
			dude.global_position = new_position
		else:
			dude.velocity = Vector2.ZERO  

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(0, 1)

func is_within_tilemap_bounds(position):
	var tilemap = GameController.tilemap
	var cell = tilemap.local_to_map(position)
	return tilemap.get_cell_source_id(0, cell) != -1 
