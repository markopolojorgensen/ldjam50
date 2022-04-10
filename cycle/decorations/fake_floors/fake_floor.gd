extends Area2D

const shrapnel_scene = preload("res://cycle/shrapnel/shrapnel.tscn")

export(bool) var require_punch = false

# per boom line
export(int) var shrapnel_count = 25

func _ready():
	show()
	connect("body_entered", self, "player_detected")

func player_detected(_body):
	if not require_punch:
		call_deferred("kaboom")

func punch_detected():
	if require_punch:
		call_deferred("kaboom")

func kaboom():
	hide()
	var room = find_parent("room")
	for side_a in $boom_lines.get_children():
		var side_b = side_a.get_child(0)
		for i in range(shrapnel_count):
			var shrapnel = shrapnel_scene.instance()
			room.add_child(shrapnel)
			var weight = i / float(shrapnel_count - 1)
			shrapnel.global_position = (side_a as Position2D).global_position.linear_interpolate(side_b.global_position, weight)
			var here_to_there = shrapnel.global_position - global_position
			shrapnel.apply_central_impulse(here_to_there.normalized() * 500)
	
	queue_free()




















