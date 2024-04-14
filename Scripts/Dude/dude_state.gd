extends Node
class_name DudeState

signal Transitioned

@export var dude: CharacterBody2D
@export var dude_animator: AnimationPlayer
@export var move_speed := 300.0

var move_direction : Vector2

func Enter():
	pass 
	
func Exit():
	pass 
	
func Update(_delta: float):
	pass 

func Physics_Update(_delta: float):
	pass 
