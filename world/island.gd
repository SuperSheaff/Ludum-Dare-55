extends Node2D

@onready var tilemap = get_node("TileMap")
@onready var area_2d = get_node("Area2D")


var velocity = Vector2.ZERO
var _direction = Vector2.ZERO
var _is_moving = false

var edges = {}
var _edge_shapes = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_island()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _physics_process(delta):
	if _is_moving:
		velocity = velocity.lerp(_direction * GameData.MAX_SPEED, GameData.ACCELERATION)
	else:
		velocity = velocity.lerp(Vector2.ZERO, GameData.FRICTION)

	position += velocity * delta
	

func get_mass():
	return len(tilemap.get_used_cells(0))



# TODO better island generation code 
func _generate_island():
	# fancy gen code here
	_get_collision_shape()
	_get_collision_edge(false)
	


# Add a CollisionShape2D corresponding to the given cell
func _add_collider(cell):
	var collision_shape = CollisionShape2D.new() 
	var center = tilemap.map_to_local(cell)
	var vertices = [
		Vector2(-GameData.TILE_WIDTH/2, 0),
		Vector2(0, GameData.TILE_HEIGHT/2),
		Vector2(GameData.TILE_WIDTH/2, 0),
		Vector2(0, -GameData.TILE_HEIGHT/2)
	]
	var shape = ConvexPolygonShape2D.new()
	shape.points = vertices
	collision_shape.shape = shape
	collision_shape.position = center
	area_2d.call_deferred("add_child", collision_shape)
	_edge_shapes[cell] = collision_shape


# Get the collisionshapes for the island cells
func _get_collision_shape():
	for cell in tilemap.get_used_cells(0):
		_add_collider(cell)
		

# Get the collisionshapes for the edge cells (no corners)
func _get_collision_edge(with_collider):
	var corners = [Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)]
	for cell in tilemap.get_used_cells(0):
		var neighbours = tilemap.get_surrounding_cells(cell)
		for neighbour in neighbours:
			if tilemap.get_cell_source_id(0, neighbour) == -1:
				if not edges.has(neighbour):
					edges[neighbour] = neighbour
					if with_collider:
						_add_collider(neighbour)







	


