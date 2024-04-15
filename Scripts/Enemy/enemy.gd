extends CharacterBody2D
class_name Enemy

var island = null

func _physics_process(delta):
	move_and_slide()
	check_and_flip_sprite()

func check_and_flip_sprite():
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
