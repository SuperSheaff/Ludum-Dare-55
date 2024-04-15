extends StaticBody2D
class_name House

@export var population : int = 0
@export var maxPopulation : int = 5

@export var coords = Vector2.ZERO

func _ready():
	position = get_parent().get_node("TileMap").map_to_local(coords)
