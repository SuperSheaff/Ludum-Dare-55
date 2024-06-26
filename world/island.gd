extends CharacterBody2D

@onready var tilemap = get_node("TileMap")
@onready var area_2d = get_node("Area2D")
const dude_scene = preload("res://Scenes/Characters/dude.tscn")
const enemy_scene = preload("res://Scenes/Characters/enemy.tscn")
const house_scene = preload("res://Scenes/Buildings/house.tscn")
const food_scene = preload("res://Scenes/Resources/food.tscn")
const ore_scene = preload("res://Scenes/Resources/ore.tscn")
const barracks_scene = preload("res://Scenes/Buildings/barracks.tscn")

#var velocity = Vector2.ZERO
var _direction = Vector2.ZERO
var _is_moving = false

var edges = {}
var _edge_shapes = {}

var population = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_island()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_dude(is_hostage):
	if is_hostage:
		var new_dude = dude_scene.instantiate()
		new_dude.island = self
		new_dude.get_node("StateMachine").change_state("Hostage")
		var house = new_dude.find_nearest_house()
		AudioManager.play("spawn", -9)
		if house:
			new_dude.house = house
			add_child(new_dude)
		
	else:
		var new_dude = dude_scene.instantiate()
		new_dude.island = self
		var house = new_dude.find_nearest_house()
		AudioManager.play("spawn", -9)
		if house:
			new_dude.house = house
			add_child(new_dude)
	
func spawn_enemy():
	var new_enemy = enemy_scene.instantiate()
	new_enemy.island = self
	add_child(new_enemy)

func get_dudes():
	var dudes = []
	for child in get_children():
		if child is Dude:
			dudes.append(child)
	return dudes
	
func get_enemies():
	var enemies = []
	for child in get_children():
		if child is Enemy:
			enemies.append(child)
	return enemies
	
func get_population():
	return len(get_dudes())
	
func get_population_limit():
	return len(get_house()) * GameData.POP_PER_HOUSE

func get_food():
	var food = []
	for child in get_children():
		if child is Food:
			food.append(child)
	return food
	
func get_barracks():
	var barracks = []
	for child in get_children():
		if child is Barracks:
			barracks.append(child)
	return barracks
	
func get_ore():
	var ore = []
	for child in get_children():
		if child is Ore:
			ore.append(child)
	return ore
	
func get_house():
	var houses = []
	for child in get_children():
		if child is House:
			houses.append(child)
	return houses
	
func _physics_process(delta):
	if _is_moving:
		velocity = velocity.lerp(_direction * GameData.MAX_SPEED, GameData.ACCELERATION)
	else:
		velocity = velocity.lerp(Vector2.ZERO, GameData.FRICTION)
	#print(position)
	move_and_slide()
	#position += velocity * delta
	

func get_mass():
	return len(tilemap.get_used_cells(0))



# TODO better island generation code 
func _generate_island():
	# fancy gen code here
	_get_collision_shape()
	_get_collision_edge(false)
	
	var house = house_scene.instantiate()
	house.coords = Vector2(-1,-1)
	#house.position = tilemap.map_to_local(house.coords)
	add_child(house)
	
	var farm = food_scene.instantiate()
	farm.coords = Vector2(-2, 1)
	#farm.position = tilemap.map_to_local(farm.coords)
	add_child(farm)
	
	var ore = ore_scene.instantiate()
	ore.coords = Vector2(0, -1)
	#ore.position = tilemap.map_to_local(ore.coords)
	add_child(ore)
	
	var barracks = barracks_scene.instantiate()
	barracks.coords = Vector2(0, 1)
	#barracks.position = tilemap.map_to_local(barracks.coords)
	add_child(barracks)
	
	spawn_enemy()
	spawn_dude(true)

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
	call_deferred("add_child", collision_shape)
	
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape
	collision_shape.position = center
	
	area_2d.call_deferred("add_child", collision_shape)
	
	
# Add a CollisionShape2D corresponding to the given cell
func _add_collider_edge(cell):
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
func _get_collision_edge(with_collider=false):
	var corners = [Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)]
	for cell in tilemap.get_used_cells(0):
		var neighbours = tilemap.get_surrounding_cells(cell)
		for neighbour in neighbours:
			if tilemap.get_cell_source_id(0, neighbour) == -1:
				if not edges.has(neighbour):
					edges[neighbour] = neighbour
					if with_collider:
						_add_collider_edge(neighbour)







	


