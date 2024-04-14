extends DudeIdle
class_name DudeIdlePause

var pause_time : float

func Enter():
	super.Enter()
	
	randomize_pause()
	dude_animator.play("idle")
	
func Update(delta: float):
	super.Update(delta)
	
	if pause_time > 0:
		pause_time -= delta
		
	else:
		Transitioned.emit(self, "IdleRoam")

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	
	if dude:
		dude.velocity = Vector2.ZERO

func randomize_pause():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	pause_time = randf_range(0, 1)
