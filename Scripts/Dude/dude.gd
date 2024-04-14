extends CharacterBody2D
class_name Dude

var task = null
var house : House

func _physics_process(delta):
	move_and_slide()
	check_and_flip_sprite()

func check_and_flip_sprite():
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func check_for_task():
	return GameController.check_for_task(position)
	 
func get_task():
	return task
	
func set_task(new_task):
	task = new_task
	
func set_house(new_house):
	house = new_house
	
func get_house_position():
	return house.position
