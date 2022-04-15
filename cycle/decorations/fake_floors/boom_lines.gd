extends Node2D

export(int) var shrapnel_count = 25

const shrapnel_scene = preload("res://cycle/shrapnel/shrapnel.tscn")

# Call deferred, please!
func kaboom():
	hide()
	var room = find_parent("room")
	for side_a in get_children():
		var side_b = side_a.get_child(0)
		for i in range(shrapnel_count):
			var shrapnel = shrapnel_scene.instance()
			room.add_child(shrapnel)
			var weight = i / float(shrapnel_count - 1)
			shrapnel.global_position = (side_a as Position2D).global_position.linear_interpolate(side_b.global_position, weight)
			var here_to_there = shrapnel.global_position - global_position
			shrapnel.apply_central_impulse(here_to_there.normalized() * 500)
