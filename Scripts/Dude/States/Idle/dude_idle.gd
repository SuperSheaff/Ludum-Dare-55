extends DudeState
class_name DudeIdle

var task

func Update(delta: float):
	
	task = dude.check_for_task()
	
	if task is Food:
		dude.set_task(task)
		Transitioned.emit(self, "MoveToFood")
		print("Received Food task")
		
	elif task is Ore:
		dude.set_task(task)
		Transitioned.emit(self, "MoveToOre")
		print("Received Ore task")
		
	elif task is Barracks:
		dude.set_task(task)
		Transitioned.emit(self, "WarriorRoam")
		print("Received Warrior task")
		
	#elif task is Pray:
		#dude.set_task(task)
		#Transitioned.emit(self, "MoveToPray")
		#print("Received Pray task")
	
