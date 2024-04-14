extends Node

const dude_scene = preload("res://Scenes/Characters/dude.tscn")
@onready var tilemap = get_node("/root/Main/TileMap")

var current_food = 0

func _ready():
	spawn_dude()

func check_for_task(dude_position):
	var closest_resource = null
	var min_distance = INF  # Set to infinity to ensure any real distance is shorter
	var resource_type = null  # Keeps track of whether the closest resource is food or ore

	# Get all Food instances in the scene
	var food_items = get_tree().get_nodes_in_group("Food")
	for food in food_items:
		if not food.is_assigned:
			var distance = dude_position.distance_to(food.global_position)
			if distance < min_distance:
				min_distance = distance
				closest_resource = food
				resource_type = "food"

	# Get all Ore instances in the scene
	var ore_items = get_tree().get_nodes_in_group("Ore")
	for ore in ore_items:
		if not ore.is_assigned:
			var distance = dude_position.distance_to(ore.global_position)
			if distance < min_distance:
				min_distance = distance
				closest_resource = ore
				resource_type = "ore"

	# If a closest resource is found, assign it to the dude
	if closest_resource:
		if resource_type == "food":
			closest_resource.assign_to_dude()  # Mark the food as assigned
		elif resource_type == "ore":
			closest_resource.assign_to_dude()  # Mark the ore as assigned
		return closest_resource

	return null

	
func spawn_dude():
	var new_dude = dude_scene.instantiate()
	var house = find_nearest_house(new_dude.global_position)  # Assuming a method to find the nearest house
	if house:
		new_dude.house = house  # Assign house to Dude
		house.add_child(new_dude)  # Add the new Dude to the scene
		print("Dude spawned and assigned to house at position: ", house.global_position)

func find_nearest_house(dude_position):
	var houses = get_tree().get_nodes_in_group("Houses")  # Assuming all houses are in a group named "Houses"
	var nearest_house = null
	var min_distance = INF

	for house in houses:
		var distance = dude_position.distance_to(house.global_position)
		if distance < min_distance:
			min_distance = distance
			nearest_house = house

	return nearest_house
	
func add_food():
	current_food += 1
	if current_food >= 4:
		spawn_dude()
		current_food = 0  # Reset current_food if needed, or manage this differently depending on game logic
	print("Food: ", current_food)
	
