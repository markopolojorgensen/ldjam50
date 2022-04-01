extends Node2D

var net_detection_direction := Vector2()

func _physics_process(_delta):
	global_rotation = 0
	net_detection_direction = Vector2()
	for child in get_children():
		if not child is RayCast2D:
			breakpoint
		var ray : RayCast2D = (child as RayCast2D)
		if ray.is_colliding():
			net_detection_direction += ray.cast_to.normalized()


