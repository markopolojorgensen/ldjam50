extends Node2D

var cycle_time = 6000

func _enter_tree():
	global.current_cycle = self

func get_world():
	return self


