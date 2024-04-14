extends DudeState
class_name DudeIdle

var task

#func Enter():
	#print("Test")
	

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
		
	#elif task is Metal:
		#print("Received metal task")
	#else:
		#print("Unknown task")
