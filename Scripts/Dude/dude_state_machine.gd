extends Node

@export var initial_state : DudeState

var current_state : DudeState
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is DudeState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
	
func change_state(new_state_name):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	current_state.Exit()
	new_state.Enter()
