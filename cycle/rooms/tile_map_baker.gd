tool
extends TileMap


export(bool) var bake_tilemap = false setget set_bake_tilemap

export(String, "single_convex", "multiple_concave") var bake_style = "multiple_concave"
export(bool) var remove_unecessary_points = true
export(bool) var handle_bad_neighbors = true

func set_bake_tilemap(new_value):
	if new_value:
		match bake_style:
			"single_convex":
				call_deferred("bake_singular_convex_tile_map")
			"multiple_concave":
				call_deferred("bake_multiple_concave_tile_map")
	bake_tilemap = false

# generates one convex collision shape
func bake_singular_convex_tile_map():
	var static_body = StaticBody2D.new()
	add_child(static_body)
	print(owner)
	static_body.set_owner(owner)
	var tile_set_shapes = tile_set.tile_get_shapes(0) # one tile, the autotile
	var cell_positions : Array = get_used_cells()
	var giant_point_cloud = PoolVector2Array()
#	print(Geometry.convex_hull_2d([
#		Vector2(0, 0),
#		Vector2(1, 0),
#		# Vector2(0.5, 0), # on a straight line
#		# Vector2(0.9, 0.1), # inside the prescribed triangle
#		Vector2(1, 1),
#	]))
	# adds all tiles' points to a single cloud
	while 0 < cell_positions.size():
		var cell_position = cell_positions.pop_front()
		var auto_tile_coord = get_cell_autotile_coord(cell_position.x, cell_position.y)
		var tile_shape = get_tile_shape(tile_set_shapes, auto_tile_coord)
		var tile_global_pos = map_to_world(cell_position)
		if tile_shape != null:
			# print(tile_shape.points)
			for point in tile_shape.points:
				giant_point_cloud.append(point + tile_global_pos)
	var giant_collision_polygon = CollisionPolygon2D.new()
	giant_collision_polygon.polygon = Geometry.convex_hull_2d(giant_point_cloud)
	# var polygon_shape = ConvexPolygonShape2D.new()
	# polygon_shape.set_point_cloud(giant_point_cloud)
	# print("condensed shape down to %d points" % polygon_shape.points.size())
	# giant_collision_shape.shape = polygon_shape
	static_body.add_child(giant_collision_polygon)
	giant_collision_polygon.set_owner(owner)

func bake_multiple_concave_tile_map():
	print("baking tile map...")
	# print("owner: %s" % owner.name)
	var static_body = StaticBody2D.new()
	add_child(static_body)
	static_body.set_owner(owner) # so it appears in the editor scene tree
	var tile_set_shapes = tile_set.tile_get_shapes(0) # one tile, the autotile
	var cell_positions : Array = get_used_cells()
	print("  (%d tiles to go consider)" % cell_positions.size())
	
	var explored_cell_positions = []
	
	while 0 < cell_positions.size():
		# print("new search")
		# new bfs
		var root : Vector2 = cell_positions.pop_front()
		explored_cell_positions.append(root)
		var cell_positions_to_explore = [root]
		var polygon = PoolVector2Array()
		while 0 < cell_positions_to_explore.size():
			# yield(get_tree(), "idle_frame")
			var cell_position : Vector2 = cell_positions_to_explore.pop_front()
			var is_valid_exploration = true
			# print("    exploring %s" % str(cell_position))
			
			# expand shape
			var auto_tile_coord = get_cell_autotile_coord(int(cell_position.x), int(cell_position.y))
			var tile_shape = get_tile_shape(tile_set_shapes, auto_tile_coord)
			if tile_shape == null:
				pass
				# print("      (no tile shape)")
			else:
				var tile_global_pos = map_to_world(cell_position)
				var tile_shape_global_points = []
				for point in tile_shape.points:
					# yield(get_tree(), "idle_frame")
					tile_shape_global_points.append(point + tile_global_pos)
				# print("      autotile coord: %s | global coord:s %s" % [auto_tile_coord, tile_shape_global_points])
				
				if polygon.size() <= 0:
					for global_point in tile_shape_global_points:
						polygon.append(global_point)
				else:
					# expand polygon based on new points
					# find shared edges
					var polygon_shared_edge_indices = []
					var polygon_shared_edge_first_index = -1
					for i in range(polygon.size()):
						# yield(get_tree(), "idle_frame")
						var global_point = polygon[i]
						if global_point in tile_shape_global_points:
							# is this the first point of the edge?
							var next_index = (i + 1) % polygon.size()
							var previous_index = (i - 1) % polygon.size()
							if (polygon[next_index] in tile_shape_global_points) and (not polygon[previous_index] in tile_shape_global_points):
								polygon_shared_edge_first_index = i
								break
					
					# find all the edge points
					if 0 <= polygon_shared_edge_first_index:
						# print("      finding shared edge points starting at %s" % polygon[polygon_shared_edge_first_index])
						polygon_shared_edge_indices.append(polygon_shared_edge_first_index)
						var i = 1
						# keep looping until we find an index of a point that's not shared
						var keep_looping = true
						while keep_looping:
							# yield(get_tree(), "idle_frame")
							keep_looping = false
							var index = (polygon_shared_edge_first_index + i) % polygon.size()
							if polygon[index] in tile_shape_global_points:
								# print("        found shared edge point: %s" % str(polygon[index]))
								polygon_shared_edge_indices.append(index)
								keep_looping = true
							i += 1
					
					if 0 < polygon_shared_edge_indices.size():
						# print("      edge points: %s" % str(polygon_shared_edge_indices))
						
						var first_point = polygon[polygon_shared_edge_indices.front()]
#						var second_point = polygon[polygon_edge_second_point_index]
#
						var tile_edge_first_point_index = tile_shape_global_points.find(first_point)
#						var tile_edge_second_point_index = tile_shape_global_points.find(second_point)
#
						var tile_non_edge_index = (tile_edge_first_point_index + 1) % tile_shape_global_points.size()
						var keep_looping = true
						var points_inserted = 0
						while keep_looping:
							# yield(get_tree(), "idle_frame")
							keep_looping = false
							var tile_shape_global_point = tile_shape_global_points[tile_non_edge_index]
							if not tile_shape_global_point in polygon:
								var polygon_insert_index = polygon_shared_edge_indices.front() + 1 + points_inserted
								polygon.insert(polygon_insert_index, tile_shape_global_point)
								points_inserted += 1
								# print("        inserted %s at %d" % [tile_shape_global_point, polygon_insert_index])
								keep_looping = true
							tile_non_edge_index = (tile_non_edge_index + 1) % tile_shape_global_points.size()
						
						var polygon_edge_indices_to_remove_count = polygon_shared_edge_indices.size() - 2
						if 0 < polygon_edge_indices_to_remove_count:
							for _i in range(polygon_edge_indices_to_remove_count):
								var polygon_index_to_erase = polygon_shared_edge_indices.front() + 1 + points_inserted
								# print("        erasing polygon index %d (%s)" % [polygon_index_to_erase, str(polygon[polygon_index_to_erase])])
								polygon.remove(polygon_index_to_erase)
					
					if handle_bad_neighbors and polygon_shared_edge_first_index == -1:
						# this neighbor doesn't actually connect
						cell_positions.append(cell_position)
						explored_cell_positions.erase(cell_position)
						is_valid_exploration = false
						# print("        bad neighbor at %s" % str(cell_position))
					
				# print("      polygon: %s" % str(polygon))
			
			if is_valid_exploration:
				var neighbors = [
					cell_position + Vector2(-1, 0),
					cell_position + Vector2(1, 0),
					cell_position + Vector2(0, -1),
					cell_position + Vector2(0, 1),
				]
				for neighbor in neighbors:
					if (not neighbor in explored_cell_positions) and (neighbor in cell_positions):
						cell_positions.erase(neighbor)
						explored_cell_positions.append(neighbor)
						cell_positions_to_explore.append(neighbor)
		
		# if there are three subsequent points in a straight line, the middle point is unnecessary
		if remove_unecessary_points:
			var keep_looping = true
			while keep_looping:
				keep_looping = false
				for i in range(polygon.size()):
					var next_i     = (i + 1) % polygon.size()
					var previous_i = (i - 1) % polygon.size()
					var previous_point = polygon[previous_i]
					var current_point  = polygon[i]
					var next_point     = polygon[next_i]
					var angle_diff = previous_point.direction_to(current_point).angle() - previous_point.direction_to(next_point).angle()
					if abs(rad2deg(angle_diff)) < 0.01: # one hundreth of a degree
						polygon.remove(i)
						keep_looping = true
						break
		
		
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = polygon
		static_body.add_child(collision_polygon)
		collision_polygon.set_owner(owner)
	
	print("...done baking tile map")




func get_tile_shape(tile_set_shapes, auto_tile_coord):
	for shape_dict in tile_set_shapes:
		# print(shape_dict["autotile_coord"])
		if shape_dict["autotile_coord"] == auto_tile_coord:
			return shape_dict["shape"]
	# print("no such autotile coord: %s" % str(auto_tile_coord))



