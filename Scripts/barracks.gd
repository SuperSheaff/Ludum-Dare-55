extends Node2D
class_name Barracks

var is_assigned = false

func assign_to_dude():
	is_assigned = true

func unassign():
	is_assigned = false