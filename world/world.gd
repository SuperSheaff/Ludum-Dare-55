extends Node2D


var island_scene = preload("res://World/island.tscn")

@onready var player = get_node("Player")

var _active_islands = []
const MIN_SPAWN_DIST = 1500
const MAX_SPAWN_DIST = 1000
var DESPAWN_DISTANCE = 20000
const MAX_ISLANDS = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_island(Vector2(0,0))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _active_islands.size() < MAX_ISLANDS:
		spawn_islands()
	despawn_islands()
	
	pass


func spawn_islands():
	var player_pos = player.position
	var angle = randf_range(0, 2 * PI)  # Random angleg in radians
	var diag = Vector2.ZERO.distance_to(get_viewport().size/2)
	print(diag)
	var distance = randf_range(diag + 500, diag + 2000)  # Random spawn distance
	#DESPAWN_DISTANCE = diag + 500
	var spawn_pos = player_pos + Vector2(cos(angle), sin(angle)) * distance
	add_island(spawn_pos)


func despawn_islands():
	for isle in _active_islands:
		if isle.position.distance_to(player.position) > DESPAWN_DISTANCE:
			remove_island(isle)


func add_island(position):
	var isle = island_scene.instantiate()
	isle.global_position = position
	add_child(isle)
	isle.generate_island()
	_active_islands.append(isle)
	

func remove_island(island):
	_active_islands.erase(island)
	island.queue_free()  # Properly remove the island from the scene


func island_exists_at(position):
	for isle in _active_islands:
		if isle.global_position.distance_to(position) < MIN_SPAWN_DIST:
			return true
	return false
