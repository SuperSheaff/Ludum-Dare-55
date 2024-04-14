extends DudeState
class_name DudeFood

var food 
var collect_distance = 50  # Distance at which dude starts collecting
var collect_duration = 0.5

var house_distance = 50 
var house_position

func Enter():
	if food == null:
		food = dude.get_task()
	
	house_position = dude.get_house_position()  # You need to define how to get the house position

