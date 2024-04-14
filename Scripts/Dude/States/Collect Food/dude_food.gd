extends DudeState
class_name DudeFood

var food 
var collect_distance = 50
var collect_duration = 0.5

var house_distance = 50 
var house_position

func Enter():
	if food == null:
		food = dude.get_task()
	
	house_position = dude.get_house_position() 
