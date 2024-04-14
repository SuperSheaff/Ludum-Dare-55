extends DudeState
class_name DudeOre

var ore 
var collect_distance = 50
var collect_duration = 0.5

var house_distance = 50 
var house_position

func Enter():
	if ore == null:
		ore = dude.get_task()
	
	house_position = dude.get_house_position()

