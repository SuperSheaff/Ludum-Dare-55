extends Node

const dude_scene = preload("res://Scenes/Characters/dude.tscn")
@onready var tilemap = get_node("/root/Main/TileMap")

var current_food = 0
var current_ore = 0

func _ready():
	spawn_dude()
	spawn_dude()

func check_for_task(dude_position):
	var closest_task = null
	var min_distance = INF  # Using a high initial distance to compare against
	var resource_type = null

	# First, try to find the closest unassigned food item
	var food_items = get_tree().get_nodes_in_group("Food")
	for food in food_items:
		if not food.is_assigned:
			var distance = dude_position.distance_to(food.global_position)
			if distance < min_distance:
				min_distance = distance
				closest_task = food
				resource_type = "food"

	# Only check for ore if no unassigned food was found
	if closest_task == null:
		var ore_items = get_tree().get_nodes_in_group("Ore")
		for ore in ore_items:
			if not ore.is_assigned:
				var distance = dude_position.distance_to(ore.global_position)
				if distance < min_distance:
					min_distance = distance
					closest_task = ore
					resource_type = "ore"
					
	# Only check for ore if no unassigned food was found
	if closest_task == null:
		var barracks_items = get_tree().get_nodes_in_group("Barracks")
		for barracks in barracks_items:
			if barracks && current_ore >= 4:
				current_ore -= 4
				var distance = dude_position.distance_to(barracks.global_position)
				if distance < min_distance:
					min_distance = distance
					closest_task = barracks
					resource_type = "barracks"

	# Assign the dude to the resource if one is found
	if closest_task:
		closest_task.assign_to_dude()
		return closest_task

	return null
	
func spawn_dude():
	var new_dude = dude_scene.instantiate()
	var house = find_nearest_house(new_dude.global_position)
	AudioManager.play("spawn", -9)
	if house:
		new_dude.house = house
		house.add_child(new_dude)
		
		print("Dude spawned and assigned to house at position: ", house.global_position)

func find_nearest_house(dude_position):
	var houses = get_tree().get_nodes_in_group("Houses")
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
		current_food = 0
	print("Food: ", current_food)
	
func add_ore():
	current_ore += 1
	print("Ore: ", current_ore)
	
