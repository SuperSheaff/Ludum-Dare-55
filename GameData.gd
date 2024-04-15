extends Node

const TILE_WIDTH : int = 160
const TILE_HEIGHT : int = 80


var MAX_SPEED : float = 500
var ACCELERATION : float = 0.5
var FRICTION : float = 0.1

var current_food = 0
var current_ore = 0
var population = 1

const COLLIDE_THRESHOLD = 25
const POP_PER_HOUSE = 4
const DUDE_COST = 4
const WARRIOR_COST = 4
const BASE_DAMAGE = 1
const BASE_HEALTH = 5
const DUDE_MOVE_SPEED = 150
const MAX_ISLANDS = 3

var player = null
var world = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_food():
	current_food += 1
	if current_food >= DUDE_COST:
		if player.get_population() < player.get_population_limit():
			player.spawn_dude(false)
			current_food -= DUDE_COST
			
	world.food_icon.text = ": " + str(current_food)
	print("Food: ", current_food)
	

func add_ore():
	current_ore += 1
	world.ore_icon.text = ": " + str(current_ore)
	print("Ore: ", current_ore)
	
func remove_ore(amount):
	current_ore -= amount
	world.ore_icon.text = ": " + str(current_ore)


func weighted_random_choice(weights):
	var total_weight = 0
	var choices = []

	# Calculate total weight and prepare the choices array
	for type in weights.keys():
		total_weight += weights[type]
		choices.append(type)

	# Generate a random number within the range of the total weight
	var random_num = randi() % total_weight
	var weight_sum = 0

	# Determine which type corresponds to the random number
	for choice in choices:
		weight_sum += weights[choice]
		if random_num < weight_sum:
			return choice

	return choices[choices.size() - 1]  # Fallback, should not really happen

