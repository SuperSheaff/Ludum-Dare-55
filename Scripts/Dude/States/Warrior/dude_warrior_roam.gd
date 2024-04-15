extends DudeWarrior
class_name DudeWarriorRoam

var target_position: Vector2

func Enter():
	super.Enter()
	randomize_wander()
	dude_animator.play("warrior_move")

func Update(delta: float):
	super.Update(delta)
	
	if dude.position.distance_to(target_position) < 10.0:
		Transitioned.emit(self, "WarriorPause")

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	if dude and target_position != null:
		var direction = (target_position - dude.position).normalized()
		dude.velocity = direction * move_speed

func randomize_wander():
	var tilemap = dude.island.tilemap
	var valid_cells = dude.island.tilemap.get_used_cells(0)
	var random_cell = valid_cells.pick_random()
	target_position = tilemap.map_to_local(random_cell) + Vector2(0.0, GameData.TILE_HEIGHT)


func is_within_tilemap_bounds(position):
	var tilemap = dude.island.tilemap
	var local_position = tilemap.to_local(position)
	var cell = tilemap.local_to_map(local_position)
	return tilemap.get_cell_source_id(0, cell) != -1 
