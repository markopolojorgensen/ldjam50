extends Node2D

# left right up down
export(String) var orientation = "up"
export(int) var parallax_offset = 16

export(bool) var add_to_layer_80 = true
export(bool) var add_to_layer_84 = true
export(bool) var add_to_layer_88 = true
export(bool) var add_to_layer_92 = true
export(bool) var add_to_layer_96 = true
export(bool) var add_to_layer_100 = true
export(bool) var add_to_layer_104 = true
export(bool) var add_to_layer_108 = true
export(bool) var add_to_layer_112 = true
export(bool) var add_to_layer_116 = true
export(bool) var add_to_layer_120 = true

func get_scene_counts():
	return $scene_counts.get_children()

func get_destination_gpos():
	return $position_2d.global_position
