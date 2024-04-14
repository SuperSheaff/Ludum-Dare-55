extends DudeFood
class_name DudeFoodCollect

@onready var food_emitter = load("res://Scenes/Emitters/food_particle.tscn")

var collect_time : float

func Enter():
	super.Enter()
	
	dude_animator.play("idle")
	collect_time = collect_duration
	
func Update(delta: float):
	super.Update(delta)
	
	if collect_time > 0:
		collect_time -= delta
		
	else:
		Transitioned.emit(self, "BringFoodHome")
		#create food emittor
		var new_food_emitter = food_emitter.instantiate()
		new_food_emitter.global_position = dude.global_position
		add_child(new_food_emitter)
		AudioManager.play("food", -10)

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	
	if dude:
		dude.velocity = Vector2.ZERO
