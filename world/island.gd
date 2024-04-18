class_name Island
extends CharacterBody2D


@onready var _tilemap: TileMap = get_node("TileMap")
@onready var _nav_region: NavigationRegion2D = get_node("NavigationRegion2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_island()
	_nav_region.navigation_polygon = _get_tilemap_polygon(10)
	_get_tilemap_colliders()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _generate_island():
	pass
	
	
func _get_tilemap_polygon(radius):
	var mesh_data = NavigationMeshSourceGeometryData2D.new()
	var polygon = NavigationPolygon.new()
	polygon.agent_radius = radius
	polygon.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_MESH_INSTANCES
	polygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	NavigationServer2D.parse_source_geometry_data(polygon, mesh_data, self)	
	NavigationServer2D.bake_from_source_geometry_data(polygon, mesh_data)	
	return polygon
	

func _get_tilemap_colliders():
	var polygon = _get_tilemap_polygon(0)
	var vertices = polygon.get_vertices()
	for j in range(polygon.get_polygon_count()):
		var indices = polygon.get_polygon(j)
		var poly = []
		for idx in indices:
			poly.append(vertices[idx])
			
		var shape = CollisionPolygon2D.new()
		shape.polygon = poly
		add_child(shape)


func get_random_target():
	var random_cell = _tilemap.get_used_cells(0).pick_random()
	return _tilemap.map_to_local(random_cell)
