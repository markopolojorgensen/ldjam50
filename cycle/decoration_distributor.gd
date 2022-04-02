extends Node2D

export(PackedScene) var decoration_scene
export(int) var decoration_count

func _ready():
	if not $position_2d:
		print('need a position!')
		breakpoint
	
	call_deferred("spawn_decorations")

func spawn_decorations():
	randomize()
	var weight = randf()
	
	for _i in range(decoration_count):
		var decoration = decoration_scene.instance()
		get_parent().add_child(decoration)
		decoration.global_position = global_position.linear_interpolate($position_2d.global_position, weight)
		if get_parent().has_method("set_original_position"):
			get_parent().set_original_position(decoration, decoration.position)
		weight = fmod(weight + 1.618, 1.0)

