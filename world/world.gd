extends Node2D


var island_scene = preload("res://World/island.tscn")

@onready var player = get_node("Player")

var _active_islands = []
const MIN_SPAWN_DIST = 1500
const MAX_SPAWN_DIST = 2000
const DESPAWN_DISTANCE = 2500
const MAX_ISLANDS = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	add_island(Vector2(0,0) 	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _active_islands.size() < MAX_ISLANDS:
		spawn_islands()
	#despawn_islands()
	
	pass


func spawn_islands():
	var player_pos = player.global_position
	var angle = randf_range(0, 2 * PI)  # Random angleg in radians
	var distance = randf_range(MIN_SPAWN_DIST, MAX_SPAWN_DIST)  # Random spawn distance
	var spawn_pos = player_pos + Vector2(cos(angle), sin(angle)) * distance
	if not island_exists_at(spawn_pos):
		add_island(spawn_pos)


func despawn_islands():
	for isle in _active_islands:
		if isle.global_position.distance_to(player.global_position) > DESPAWN_DISTANCE:
			remove_island(isle)


func add_island(position):
	var isle = island_scene.instantiate()
	isle.global_position = position
	add_child(isle)
	_active_islands.append(isle)
	

func remove_island(island):
	_active_islands.erase(island)
	island.queue_free()  # Properly remove the island from the scene



func island_exists_at(position):
	for isle in _active_islands:
		if isle.global_position.distance_to(position) < MIN_SPAWN_DIST:
			return true
	return false
