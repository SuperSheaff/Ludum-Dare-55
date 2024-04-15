extends Node2D


var island_scene = preload("res://World/island.tscn")

@onready var player = get_node("Player")
@onready var food_icon = get_node("CanvasLayer/MarginContainer/MarginContainer/HBoxContainer/FoodIcon/Label")
@onready var ore_icon = get_node("CanvasLayer/MarginContainer/MarginContainer/HBoxContainer/OreIcon/Label")
@onready var pop_icon = get_node("CanvasLayer/MarginContainer/MarginContainer/HBoxContainer/PopIcon/Label")

var _active_islands = []
var despawn_distance = 20000

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.world = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _active_islands.size() < GameData.MAX_ISLANDS:
		spawn_islands()
	despawn_islands()
	
	pop_icon.text = ": " + str(player.get_population())



func spawn_islands():
	var player_pos = player.position
	var angle = randf_range(0, 2 * PI)  # Random angleg in radians
	var diag = Vector2.ZERO.distance_to(get_viewport().size/2)
	print(diag)
	var distance = randf_range(diag + 600, diag + 1500)  # Random spawn distance
	despawn_distance = diag + 1500
	var spawn_pos = player_pos + Vector2(cos(angle), sin(angle)) * distance
	add_island(spawn_pos)


func despawn_islands():
	for isle in _active_islands:
		if isle.position.distance_to(player.position) > despawn_distance:
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

