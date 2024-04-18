class_name Worker
extends Agent


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame	# agent world not in tree yet
	_fsm.set_state("StateIdle")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
