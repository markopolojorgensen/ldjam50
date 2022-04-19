extends Node2D

# TO USE:
# 1. set parallax_scale
# 2. make sure the current Camera2D is in group "camera"
# 3. don't dynamically add children unless you also call set_original_position
# 4.   make sure the position is relative to this node


# This parallax does not behave like the built-in godot ParallaxLayer / ParallaxBackground
# 
# This parallax positions/moves objects such that when the current Camera2D is
# centered on an object, THAT OBJECT IS WHERE YOU PUT IT.
#
# Default parallax implementations have objects where you put them not when you
# are centered on them, but when you are centered on the layer's position
# (which is usually 0, 0). Things get more "out of sync" the farther you get from
# the layer's position. I understand why that is the most convenient way to
# implement parallax, but it's not good enough if you're placing specific 
# decorations in specific places.
#  
# This node is probably more expensive in terms of performance, since it moves
# all its children individually instead of just adjusting its own transform
# and letting that do the work. Not that much more expensive, though.

# TODO: automatically pick size for visibility notifier?

# works like motion_scale from default godot parallax
# foreground should be more than one
# background should be less than one
export(float) var parallax_scale = 1.0
export(float) var parallax_scale_v = -1

export(bool) var use_visibility_notifier = false
export(bool) var hifi_all_children_mode = false

export(bool) var debug = false
var debug_label

var camera : Camera2D
# original positions of children
# local, not global, positions
var original_positions = {}
var child_index = 0

# actually doing parallax things
# use activate() and deactivate()
export(bool) var active = true

export(bool) var auto_modulate = true

# set by visibility_notifier
var is_on_screen = false

func _enter_tree():
	if debug:
		print("WHAT THE FUCK")
		debug_label = Label.new()
		var node_2d = Node2D.new()
		node_2d.z_index = 1000
		node_2d.add_child(debug_label)
		print("debug label: %s" % str(debug_label))
		add_child(node_2d)
		set_original_position(node_2d, Vector2())

func _ready():
	original_positions[self] = position
	for child in get_children():
		original_positions[child] = child.position
	
	# wait at least one frame
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	if auto_modulate:
		var modulate_weight = abs(1.0 - parallax_scale) / 0.2
		var value = lerp(1.0, 0.375, modulate_weight)
		modulate = Color(value, value, value)
	else:
		modulate = Color.white
	
	if use_visibility_notifier:
		if $visibility_notifier_2d.is_on_screen():
			_on_visibility_notifier_2d_screen_entered()
		else:
			_on_visibility_notifier_2d_screen_exited()


# original_position is local, i.e. relative to this node
func set_original_position(child, original_position):
	original_positions[child] = original_position
	child.position = original_position

func _process(_delta):
	if not is_inside_tree():
		return
	
	if active and ((is_on_screen and use_visibility_notifier) or not use_visibility_notifier):
		position_self()
		if hifi_all_children_mode:
			all_children_process()

func single_child_process():
	# var total_start = OS.get_ticks_usec()
	# global_util.print_once(str(get_child_count()))
	if camera != null:
		# var start = OS.get_ticks_usec()
		var self_position_offset = position_self()
		var camera_center = get_camera_center()
		child_index += 1
		if get_child_count() <= child_index:
			child_index = 0
		var child = get_child(child_index)
		if not is_instance_valid(child):
			remove_child(child)
		if child.is_inside_tree():
			var motion = camera_center - child.global_position
			# not as simple as this
			# if this node is rotated (or has an ancestor that's rotated),
			#   the position adjustment is not using the same vector basis
			#   as the camera.
			# child.position = original_positions[child] + (motion * (1.0 - parallax_scale))
			child.position = original_positions[child] - self_position_offset + (motion * (1.0 - parallax_scale)).rotated(-global_rotation)
#			global_performance.log_performance_data("child_transform_calls", 1)
		# var end = OS.get_ticks_usec()
		# var tick_count = end - start
		# global_performance.log_performance_data("marko_parallax", tick_count)
#		if 500 <= tick_count:
#			print("marko parallax children ticks: %d" % tick_count)
	else:
		# find the 'current' camera
		for camera_candidate in get_tree().get_nodes_in_group("camera"):
			if camera_candidate.current:
				camera = camera_candidate
	# var total_end = OS.get_ticks_usec()
	# var ticks = total_end - total_start
#	global_performance.log_performance_data("marko_parallax_process", ticks)
#	global_performance.log_performance_data("marko_parallax_calls", 1)

func all_children_process():
	# var total_start = OS.get_ticks_usec()
	# global_util.print_once(str(get_child_count()))
	if camera != null and (0 < get_child_count()):
		# var start = OS.get_ticks_usec()
		var self_position_offset = position_self()
		var camera_center = get_camera_center()
		var to_remove = []
		for child in get_children():
			if not is_instance_valid(child):
				to_remove.append(child)
				continue
			if child.is_inside_tree():
				var motion = camera_center - child.global_position
				# not as simple as this
				# if this node is rotated (or has an ancestor that's rotated),
				#   the position adjustment is not using the same vector basis
				#   as the camera.
				# child.position = original_positions[child] + (motion * (1.0 - parallax_scale))
				child.position.x = original_positions[child].x - self_position_offset.x + (motion * (1.0 - parallax_scale)).rotated(-global_rotation).x
				if 0 <= parallax_scale_v:
					child.position.y = original_positions[child].y - self_position_offset.y + (motion * (1.0 - parallax_scale_v)).rotated(-global_rotation).y
				else:
					child.position.y = original_positions[child].y - self_position_offset.y + (motion * (1.0 - parallax_scale)).rotated(-global_rotation).y
#				global_performance.log_performance_data("child_transform_calls", 1)
		for child in to_remove:
			remove_child(child)
		# var end = OS.get_ticks_usec()
		# var tick_count = end - start
		# global_performance.log_performance_data("marko_parallax", tick_count)
#		if 500 <= tick_count:
#			print("marko parallax children ticks: %d" % tick_count)
	else:
		# find the 'current' camera
		for camera_candidate in get_tree().get_nodes_in_group("camera"):
			if camera_candidate.current:
				camera = camera_candidate
	# var total_end = OS.get_ticks_usec()
	# var ticks = total_end - total_start
#	global_performance.log_performance_data("marko_parallax_process", ticks)
#	global_performance.log_performance_data("marko_parallax_calls", 1)

func position_self():
	# var other_start = OS.get_ticks_usec()
	
	# absolutely cannot use camera.get_global_position here since that 
	# does not reflect the actual viewport location as affected by limits
	var camera_center = get_camera_center()
#	var self_motion = camera_center - global_position
	var self_motion = camera_center - (original_positions[self] + get_parent().global_position)
	
	# var other_time = OS.get_ticks_usec() - other_start
	# var calc_start = OS.get_ticks_usec()
#	var calculated_position = original_positions[self] + (self_motion * (1.0 - parallax_scale)).rotated(-global_rotation)
	var calculated_position = Vector2()
	
#	var position_adjustment = (self_motion * (1.0 - parallax_scale)).rotated(-global_rotation).x
	calculated_position.x = original_positions[self].x + (self_motion * (1.0 - parallax_scale)).rotated(-global_rotation).x
	if 0 <= parallax_scale_v:
		calculated_position.y = original_positions[self].y + (self_motion * (1.0 - parallax_scale_v)).rotated(-global_rotation).y
	else:
		calculated_position.y = original_positions[self].y + (self_motion * (1.0 - parallax_scale)).rotated(-global_rotation).y
	# var calc_time = OS.get_ticks_usec() - calc_start
	# var assign_start = OS.get_ticks_usec()
	position = calculated_position
	if debug:
		debug_label.rect_global_position = global.current_player.global_position + Vector2(-50, -80)
		# debug_label.text = "%s -> %s" % [str(original_positions[self]), str(position)]
		# debug_label.text = "%s -> %s" % [str(original_positions[self]), str(self_motion)]
		# debug_label.text = "camera center: %s | og self pos: %s |\n parent global pos: %s" % [str(camera_center), str(original_positions[self]), str(get_parent().global_position)]
		# debug_label.text = "camera center: %s \n pos_adj: %s \n wtf: %s" % [str(camera_center), str(position_adjustment), str(wtf)]
		debug_label.text = find_parent("room").get_parent().name
	# var assign_time = OS.get_ticks_usec() - assign_start
#	global_performance.log_performance_data("position_calls", 1)
#	global_performance.log_performance_data("calc_time", calc_time)
#	global_performance.log_performance_data("assign_time", assign_time)
#	global_performance.log_performance_data("other_time", other_time)
	
	return position - original_positions[self]

func get_camera_center():
	return global_parallax.get_camera_center()

func _on_visibility_notifier_2d_screen_entered():
	is_on_screen = true

func _on_visibility_notifier_2d_screen_exited():
	is_on_screen = false
	if use_visibility_notifier:
		position = original_positions[self]

func activate():
	active = true

func deactivate():
	active = false
	position = original_positions[self]




