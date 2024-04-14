extends DudeOre
class_name DudeOreCollect

@onready var ore_emitter = load("res://Scenes/Emitters/ore_particle.tscn")

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
		Transitioned.emit(self, "BringOreHome")
		#ore emit
		var new_ore_emitter = ore_emitter.instantiate()
		new_ore_emitter.global_position = dude.global_position
		add_child(new_ore_emitter)
		AudioManager.play("ore", -10)

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	
	if dude:
		dude.velocity = Vector2.ZERO
