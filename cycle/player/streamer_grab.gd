extends Line2D

var target

func _process(_delta):
	clear_points()
	
	if target != null and is_instance_valid(target) and target.is_inside_tree() and is_inside_tree():
		add_point(Vector2())
		add_point(target.global_position - global_position)
	else:
		queue_free()


