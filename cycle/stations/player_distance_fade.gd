extends Node2D


func _process(_delta):
	if not is_instance_valid(global.current_player) or not global.current_player.is_inside_tree():
		return
	
	var distance = global.current_player.global_position.distance_to(global_position)
	distance = clamp(distance - 32, 0, INF)
	var weight = clamp(distance / 200.0, 0, 1)
	var color_alpha = lerp(1.0, 0.0, weight)
	
	modulate = Color(1,1,1, color_alpha)
	
