extends Node2D

func _ready():
	show()
	call_deferred("do_decorations")

func do_decorations():
	randomize()
	var weight = randf()
	for layer in $parallax_nodes.get_children():
		if "bright" in layer.name:
			continue
		
#		print("adding decorations to layer %s" % layer.name)
		for distributor in $configuration.get_children():
			if not add_to_layer(distributor, layer):
				continue
			
			weight = increment_weight(weight)
			var parallax_weight = clamp(((layer.parallax_scale - 0.8) / 0.4), 0, 1.0)
			var position_adjustment := Vector2()
			match distributor.orientation:
				"up":
					position_adjustment = Vector2(0, distributor.parallax_offset).linear_interpolate(Vector2(0, -distributor.parallax_offset), parallax_weight)
				"down":
					position_adjustment = Vector2(0, -distributor.parallax_offset).linear_interpolate(Vector2(0, distributor.parallax_offset), parallax_weight)
				"left":
					pass
				"right":
					pass
			var scene_count_list = distributor.get_scene_counts()
			var gpos_a = distributor.global_position + position_adjustment
			var gpos_b = distributor.get_destination_gpos() + position_adjustment
			if gpos_b.x < gpos_a.x:
				var transfer = gpos_a
				gpos_a = gpos_b
				gpos_b = transfer
#			match distributor.orientation:
#				"up":
#					gpos_a.x -= lerp(0, 200, parallax_weight)
#					gpos_b.x += lerp(0, 200, parallax_weight)
#				"down":
#					pass
#				"left":
#					pass
#				"right":
#					pass
			
#			print("  from %s to %s" % [str(gpos_a), str(gpos_b)])
			assert(gpos_a.x < gpos_b.x)
			for scene_count in scene_count_list:
				weight = increment_weight(weight)
				if scene_count.only_extremes and not layer.parallax_scale in [0.8, 1.0, 1.2]:
					continue
				var decoration_count = scene_count.count
				if scene_count.back_count != -1 and layer.parallax_scale < 1.0:
					decoration_count = scene_count.back_count
				for i in range(decoration_count):
					var decoration = scene_count.decoration_scene.instance()
					if "look_right" in decoration and (randf() < 0.5):
						decoration.look_right = true
#					print("    decoration %s" % decoration.name)
					var adjusted_gpos_a = gpos_a
					var adjusted_gpos_b = gpos_b
					if "width" in decoration:
						var offset = int(round(decoration.width / 2.0))
						var check = decoration.width < abs(adjusted_gpos_a.x - adjusted_gpos_b.x)
						if not check:
							print("%s: decoration %s too wide for distributor %s" % [name, decoration.name, distributor.name])
							breakpoint
						adjusted_gpos_a.x += offset
						adjusted_gpos_b.x -= offset
					assert(adjusted_gpos_a.x < adjusted_gpos_b.x)
					layer.add_child(decoration)
					if scene_count.distribute_evenly:
						var position_weight = float(i) / (scene_count.count - 1)
						decoration.global_position = adjusted_gpos_a.linear_interpolate(adjusted_gpos_b, position_weight)
					else:
						var randomized_weight = clamp(weight + rand_range(-0.05, 0.05), 0.0, 1.0)
						decoration.global_position = adjusted_gpos_a.linear_interpolate(adjusted_gpos_b, randomized_weight)
					if layer.has_method("set_original_position"):
						layer.set_original_position(decoration, decoration.position)
					weight = increment_weight(weight)

func increment_weight(weight):
	var random_component = rand_range(-0.1, 0.1)
	return fmod(weight + 1.618 + random_component, 1.0)

func add_to_layer(distributor, layer):
#	print(layer.parallax_scale * 100)
	var property_name = "add_to_layer_%d" % int(round(layer.parallax_scale * 100))
	var result = distributor.get(property_name)
	if result == null:
		print(property_name)
		breakpoint
	return result


