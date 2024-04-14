extends DudeOre
class_name DudeOreCollect

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

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	
	if dude:
		dude.velocity = Vector2.ZERO
