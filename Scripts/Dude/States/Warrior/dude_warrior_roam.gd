extends DudeWarrior
class_name DudeWarriorRoam

var target_position: Vector2

func Enter():
	super.Enter()
	randomize_wander()
	dude_animator.play("warrior_move")

func Update(delta: float):
	super.Update(delta)
	
	if dude.global_position.distance_to(target_position) < 10.0:
		Transitioned.emit(self, "WarriorPause")

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	if dude and target_position != null:
		var direction = (target_position - dude.global_position).normalized()
		dude.velocity = direction * move_speed

func randomize_wander():
	var tilemap = GameController.tilemap
	var bounds = tilemap.get_used_rect()
	var random_cell = Vector2()
	var valid_cell_found = false

	while not valid_cell_found:
		random_cell = Vector2(
			randi() % int(bounds.size.x) + bounds.position.x,
			randi() % int(bounds.size.y) + bounds.position.y
		)
		
		if tilemap.get_cell_source_id(0, random_cell) != -1:
			valid_cell_found = true

	target_position = tilemap.map_to_local(random_cell) + tilemap.tile_set.tile_size * 0.5


func is_within_tilemap_bounds(position):
	var tilemap = GameController.tilemap
	var local_position = tilemap.to_local(position)
	var cell = tilemap.local_to_map(local_position)
	return tilemap.get_cell_source_id(0, cell) != -1 
