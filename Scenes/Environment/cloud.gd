extends Node2D

var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = randf_range(0.1, .6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed
	pass
