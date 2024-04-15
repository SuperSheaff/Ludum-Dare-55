extends Node
class_name EnemyState

signal Transitioned

@export var enemy: CharacterBody2D
@export var enemy_animator: AnimationPlayer
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
