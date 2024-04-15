extends CharacterBody2D
class_name Dude

var task = null
var house : House
var island = null
var target = null
var health = GameData.BASE_HEALTH
var current_task = null
var is_hostage = false

func _physics_process(delta):
	move_and_slide()
	check_and_flip_sprite()

func check_and_flip_sprite():
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func hit():
	health -= GameData.BASE_DAMAGE
	if health <= 0:
		die()
		
func die():
	current_task.unassign()
	#NOTE commented out as well, it doesnt have a function
	#GameData.remove_population()
	
	queue_free()

func check_for_task():
	var closest_task = null
	var min_distance = INF  # Using a high initial distance to compare against
	var resource_type = null
	
	# Warrior First Priority???
	if closest_task == null:
		var barracks_items = island.get_barracks() #get_tree().get_nodes_in_group("Barracks")
		for barracks in barracks_items:
			if barracks && GameData.current_ore >= GameData.WARRIOR_COST:
				GameData.remove_ore(GameData.WARRIOR_COST)
				var distance = position.distance_to(barracks.position)
				if distance < min_distance:
					min_distance = distance
					closest_task = barracks
					resource_type = "barracks"

	# First, try to find the closest unassigned food item
	var food_items = island.get_food() #get_tree().get_nodes_in_group("Food")
	for food in food_items:
		if not food.is_assigned:
			var distance = position.distance_to(food.position)
			if distance < min_distance:
				min_distance = distance
				closest_task = food
				resource_type = "food"

	# Only check for ore if no unassigned food was found
	if closest_task == null:
		var ore_items = island.get_ore() #get_tree().get_nodes_in_group("Ore")
		for ore in ore_items:
			if not ore.is_assigned:
				var distance = position.distance_to(ore.position)
				if distance < min_distance:
					min_distance = distance
					closest_task = ore
					resource_type = "ore"
					
	# Assign the dude to the resource if one is found
	if closest_task:
		closest_task.assign_to_dude()
		current_task = closest_task
		return closest_task

	return null
	 
func find_nearest_house():
	var houses = island.get_house() #get_tree().get_nodes_in_group("Houses")
	var nearest_house = null
	var min_distance = INF

	for house in houses:
		var distance = position.distance_to(house.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest_house = house

	return nearest_house
	
func get_task():
	return task
	
func set_task(new_task):
	task = new_task
	
func set_house(new_house):
	house = new_house
	
func get_house_position():
	return house.position
