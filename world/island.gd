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
var max_influence = 0.8
var available_cells = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_get_collision_shape()
	_get_collision_edge(false)
	
	#generate_island()
	#_generate_island()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("summon"):
		#tilemap.clear()
		#generate_island()
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


#func find_next_position(current_pos, directions):
	#var possible_positions = []
	#var checked_positions = []
	#checked_positions.append(current_pos)  # Start with the current position
	#
	#while len(possible_positions) == 0:
		#var next_positions = []
		#for pos in checked_positions:
			#for dir in directions:
				#var new_pos = pos + dir
				#if tilemap.get_cell_source_id(0, Vector2i(new_pos)) == -1 and new_pos not in possible_positions:
					#next_positions.append(new_pos)
					#
		## Check if we have any valid next positions that are not already set
		#for pos in next_positions:
			#for dir in directions:
				#var adjacent_pos = pos + dir
				#if tilemap.get_cell_source_id(0, Vector2i(adjacent_pos)) != -1:
					#possible_positions.append(pos)
					#break
	#
		#if len(possible_positions) == 0:
			#checked_positions = next_positions
#
	## Randomly select one of the possible positions
	#return possible_positions[randi() % possible_positions.size()]

# Adjusted function to find the next position
func find_next_position(current_position, directions):
	var center = calculate_geometric_center()
	var possible_positions = []
	var position_scores = []

	for dir in directions:
		var new_pos = current_position + dir
		if tilemap.get_cell_source_id(0, Vector2i(new_pos)) == -1 and new_pos not in possible_positions:
			possible_positions.append(new_pos)
			# Calculate a score based on the distance to the center, closer is better
			var score = Vector2(center).distance_to(new_pos)
			position_scores.append(score)

	# Normalize scores (lower distance means higher probability)
	if position_scores.size() > 0:
		var min_score = position_scores.min()
		var max_score = position_scores.max()
		var normalized_scores = []
		for score in position_scores:
			var normalized_score = 1.0 - (score - min_score) / (max_score - min_score)
			normalized_score = max(normalized_score, 1.0 - max_influence)
			normalized_scores.append(normalized_score)

		# Use a weighted random choice based on normalized scores
		return weighted_choice(possible_positions, normalized_scores)
	return current_position

# Function to calculate the geometric center of the set tiles
func calculate_geometric_center():
	var sum = Vector2i.ZERO
	for tile in tilemap.get_used_cells(0):
		sum += Vector2i(tile)
	return sum / len(tilemap.get_used_cells(0))

# Weighted choice function
func weighted_choice(items, weights):
	var total_weight = 0.0
	for weight in weights:
		total_weight += weight

	var random_point = randf() * total_weight
	var current_sum = 0.0
	for i in range(weights.size()):
		current_sum += weights[i]
		if current_sum >= random_point:
			return items[i]
	return items[items.size() - 1]


# TODO better island generation code 
func generate_island():
	# fancy gen code here
	
	var max_tiles = randi_range(1, GameData.player.get_population())
	
	var current_pos = Vector2i(0, 0)
	tilemap.set_cell(0, current_pos, 2, Vector2i(0, 0))
	
	var directions = [
		Vector2i.RIGHT,
		Vector2i.LEFT,
		Vector2i.UP,
		Vector2i.DOWN
	]
	
	for i in range(1, max_tiles):
		current_pos = find_next_position(current_pos, directions)
		tilemap.set_cell(0, current_pos, 2, Vector2i(0, 0))
		
	_get_collision_shape()
	_get_collision_edge(false)

	var num_tiles = len(tilemap.get_used_cells(0))
	available_cells = tilemap.get_used_cells(0).duplicate()
	
	if num_tiles < 3:
		var weights = {
			"ore": 40,
			"food": 30,
			"barracks": 10,
			"house": 30,
			"null": 20
		}
		var selected = GameData.weighted_random_choice(weights)
		add_object(selected)
	elif num_tiles < 9:
		var weights = {
			"ore": 40,
			"food": 30,
			"barracks": 10,
			"house": 30,
			"null": 20
		}
		var num_weights = {
			1: 40,
			2: 30,
			3: 10,
			4: 20
		}
		var num_objs = GameData.weighted_random_choice(num_weights)
		for i in range(num_objs):
			var selected = GameData.weighted_random_choice(weights)
			add_object(selected)


func add_object(object_type):
	if object_type == "null":
		return
		
	if len(available_cells) == 0:
		return
	
	var pos = available_cells.pick_random()
	available_cells.erase(pos)
	var obj = null
	
	match(object_type):
		"food":	#food
			obj = food_scene.instantiate()
		"ore":
			obj = ore_scene.instantiate()
		"barracks":
			obj = barracks_scene.instantiate()
		"house":
			obj = house_scene.instantiate()
			
		
	obj.coords = pos
	add_child(obj)
			
			
	

	#var house = house_scene.instantiate()
	#house.coords = Vector2(-1,-1)
	##house.position = tilemap.map_to_local(house.coords)
	#add_child(house)
	#
	#var farm = food_scene.instantiate()
	#farm.coords = Vector2(-2, 1)
	##farm.position = tilemap.map_to_local(farm.coords)
	#add_child(farm)
	#
	#var ore = ore_scene.instantiate()
	#ore.coords = Vector2(0, -1)
	##ore.position = tilemap.map_to_local(ore.coords)
	#add_child(ore)
	
	#var barracks = barracks_scene.instantiate()
	#barracks.coords = Vector2(0, 1)
	##barracks.position = tilemap.map_to_local(barracks.coords)
	#add_child(barracks)
	#
	#spawn_enemy()
	#spawn_dude(true)
	
	pass

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







	


