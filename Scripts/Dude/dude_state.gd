extends Node
class_name DudeState

signal Transitioned

@export var dude: CharacterBody2D
@export var dude_animator: AnimationPlayer
@export var move_speed := GameData.DUDE_MOVE_SPEED

var move_direction : Vector2

func Enter():
	pass 
	
func Exit():
	pass 
	
func Update(_delta: float):
	pass 

func Physics_Update(_delta: float):
	pass 
