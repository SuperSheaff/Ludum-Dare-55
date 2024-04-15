extends 'island.gd'



@onready var camera = get_node("Camera2D")
@onready var world = get_parent()


# DEBUG
var point1 = Vector2.ZERO
var point2 = Vector2.ONE * INF

var other_island = null
var other_point_tm = Vector2.ZERO
var local_point_tm = Vector2.ZERO

var collisions = {}

var _mass = 1



func _ready():
	_get_collision_edge(true)
	GameController.spawn_dude(self)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	_get_aim_direction()		
	
	_check_collisions(delta)
			
	_is_moving = Input.is_action_pressed("summon")
			
	queue_redraw()

	
func _draw():
	for key in collisions.keys():
		for cs in collisions[key]:
			var pos = cs.position + cs.get_parent().get_parent().position
			draw_line(area_2d.get_node(key).position, pos-position, Color.WHITE, 5.0)


func _get_aim_direction():
	var screen_scale = (Vector2(get_viewport().size)) / 2# / get_viewport_rect().size)
	var mouse_pos = get_viewport().get_mouse_position()
	_direction = (mouse_pos - screen_scale).normalized()


func _island_collision(local_cs, other_cs, delta):
	camera.camera_shake()
	_collision_physics(other_cs.get_parent().get_parent(), delta)
	_merge_island(local_cs, other_cs)
	camera.update_camera_zoom_pos()
	collisions.clear()


func _collision_physics(collision, delta):
	var other_mass = 1.0 

	var combined_mass = _mass + other_mass
	var new_velocity = (velocity * _mass + collision.velocity * other_mass) / combined_mass

	var elasticity = 0.8
	new_velocity *= elasticity

	velocity = new_velocity
	

func _merge_island(local_cs, other_cs):
	var tm = other_cs.get_parent().get_parent().tilemap
	
	var other_point = other_cs.position
	var local_point = area_2d.get_node(local_cs).position
	
	other_point_tm = tm.local_to_map(other_point)
	local_point_tm = tilemap.local_to_map(local_point)
	other_island = other_cs.get_parent().get_parent()
	
	# Add edge tiles from new island	
	for edge in other_island.edges.values():
		var new = local_point_tm + edge - other_point_tm
		if tilemap.get_cell_source_id(0, new) == -1:
			if not edges.has(new):
				edges[new] = new
				_add_collider(new)

	# Add main tiles from new island and delete invalid edges
	for cell in other_island.tilemap.get_used_cells(0):
		var new = local_point_tm + cell - other_point_tm
		tilemap.set_cell(0, new, 2, Vector2i(0, 0))
		if edges.has(new):
			edges.erase(new)
			_edge_shapes[new].queue_free()
			_edge_shapes.erase(new)
		
	# Update tilemap and remove other island
	tilemap.force_update()
	world.remove_island(other_island)
	other_island = null
	

func _check_collisions(delta):
	for edge in collisions.keys():
		var nearest = INF
		var other_cs = null
		var edge_obj = area_2d.get_node(edge)
		
		for cs in collisions[edge]:
			var pos = cs.position + cs.get_parent().get_parent().position
			var dist = edge_obj.position.distance_to(pos - position)
			if dist < nearest:
				other_cs = cs
				nearest = dist

		if nearest < GameData.COLLIDE_THRESHOLD:
			_island_collision(edge, other_cs, delta)
			break
	

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):	
	var other_shape_owner = area.shape_find_owner(area_shape_index)
	var other_shape_node = area.shape_owner_get_owner(other_shape_owner)
	
	var local_shape_owner = area_2d.shape_find_owner(local_shape_index)
	var local_shape_node = area_2d.shape_owner_get_owner(local_shape_owner)
	
	if not collisions.has(local_shape_node.name):
		collisions[local_shape_node.name] = []
	
	if not other_shape_node in collisions[local_shape_node.name]:
		collisions[local_shape_node.name].append(other_shape_node)


func _on_area_2d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if len(collisions) == 0:
		return 
		
	var other_shape_owner = area.shape_find_owner(area_shape_index)
	var other_shape_node = area.shape_owner_get_owner(other_shape_owner)
	
	var local_shape_owner = area_2d.shape_find_owner(local_shape_index)
	var local_shape_node = area_2d.shape_owner_get_owner(local_shape_owner)

	collisions[local_shape_node.name].erase(other_shape_node)

	if len(collisions[local_shape_node.name]) == 0:
		collisions.erase(local_shape_node.name)
	
