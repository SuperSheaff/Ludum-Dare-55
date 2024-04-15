extends Node2D
class_name Monolith

@export var coords = Vector2.ZERO
var is_assigned = false

func assign_to_dude():
	is_assigned = true

func unassign():
	is_assigned = false


func _ready():
	position = get_parent().get_node("TileMap").map_to_local(coords)
