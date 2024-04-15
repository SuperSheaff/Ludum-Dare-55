extends EnemyWarrior
class_name EnemyWarriorRoam

var target_position: Vector2
var dudes = []

func Enter():
	super.Enter()
	randomize_wander()
	enemy_animator.play("enemy_warrior_move")
	dudes = enemy.island.get_dudes()

func Update(delta: float):
	super.Update(delta)
	
	if enemy.position.distance_to(target_position) < 10.0:
		Transitioned.emit(self, "EnemyWarriorPause")
		
	if len(dudes) > 0:
		enemy.target = dudes.pick_random()
		if not enemy.target.is_hostage:
			Transitioned.emit(self, "EnemyWarriorHunt")


func Physics_Update(delta: float):
	super.Physics_Update(delta)
	if enemy and target_position != null:
		var direction = (target_position - enemy.position).normalized()
		enemy.velocity = direction * move_speed

func randomize_wander():
	var tilemap = enemy.island.tilemap
	var valid_cells = enemy.island.tilemap.get_used_cells(0)
	var random_cell = valid_cells.pick_random()
	target_position = tilemap.map_to_local(random_cell) + Vector2(0.0, GameData.TILE_HEIGHT)

func is_within_tilemap_bounds(position):
	var tilemap = enemy.island.tilemap
	var local_position = tilemap.to_local(position)
	var cell = tilemap.local_to_map(local_position)
	return tilemap.get_cell_source_id(0, cell) != -1 
