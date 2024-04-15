extends Node

const TILE_WIDTH : int = 160
const TILE_HEIGHT : int = 80


var MAX_SPEED : float = 500
var ACCELERATION : float = 0.5
var FRICTION : float = 0.1

var current_food = 0
var current_ore = 0
var population = 0

const COLLIDE_THRESHOLD = 25
const POP_PER_HOUSE = 4
const DUDE_COST = 4
const WARRIOR_COST = 4

var player = null

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
	print("Food: ", current_food)
	
func add_ore():
	current_ore += 1
	print("Ore: ", current_ore)
