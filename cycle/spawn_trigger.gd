extends Area2D

var spawned = false

func _ready():
	pass
	# connect("body_entered", self, "_on_spawn_trigger_body_entered")

func _on_spawn_trigger_body_entered(_body):
#	var spawn_count = 0
#	var reset_count = 0
	for child in get_children():
		if not spawned:
			if child.has_method("spawn"):
				child.call_deferred("spawn")
#				spawn_count += 1
		else:
			if child.has_method("reset"):
				child.call_deferred("reset")
#				reset_count += 1
#	print("%d spawners spawned, %d spawners reset" % [spawn_count, reset_count])
	spawned = true












