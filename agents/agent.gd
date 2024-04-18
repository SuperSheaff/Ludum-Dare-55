class_name Agent
extends Node2D

@onready var _fsm = get_node("StateMachine")
@onready var _sprite = get_node("Sprite2D")
@onready var anim_player = get_node("AnimationPlayer")

@export var world: Node
@export var data: AgentData = AgentData.new()


var _velocity: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO
var _target_position: Vector2 = Vector2.ZERO
var _path: PackedVector2Array = []
var _path_index: int = 0
var navigation_finished = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _physics_process(delta):
	if navigation_finished:
		_velocity = _velocity.lerp(Vector2.ZERO, data.friction)
	else:
		_direction = position.direction_to(get_next_path_position())
		_velocity = _velocity.lerp(_direction * data.max_speed, data.acceleration)
		
	_sprite.set_flip_h(sign(_direction.x) <= 0)
		
	position += _velocity * delta
	

func get_next_path_position():
	if not len(_path):
		return position
		
	if position.distance_squared_to(_path[_path_index]) < 100:
		_path_index += 1
	
	if _path_index >= len(_path):
		navigation_finished = true
		return position
		
	return _path[_path_index]


func set_target(target_position):
	_path_index = 0
	_target_position = target_position
	var rid = NavigationServer2D.get_maps()[0]		# need to change
	_path = NavigationServer2D.map_get_path(rid, global_position, _target_position+world.position, false)

	for i in range(len(_path)):
		_path[i] = _path[i] - world.position
		
	navigation_finished = false


## DEBUG
#func _draw():
	#for i in range(1, len(_path)):
		#draw_line(_path[i-1] - position, _path[i] - position, Color.RED, 2)
		#draw_circle(_path[i] - position, 4, Color.RED)

