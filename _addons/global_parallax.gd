extends Node2D

var last_frame = -1
var cached_camera_center : Vector2


func get_camera_center():
	if Engine.get_idle_frames() != last_frame:
		cached_camera_center = _update_camera_center()
		last_frame = Engine.get_idle_frames()
		# print("updating camera center cache")
	return cached_camera_center


# from https://godotengine.org/qa/13740/get-camera-extents-rect-2d
func _update_camera_center():
	# Get the canvas transform
	var ctrans = get_canvas_transform()
	
	# The canvas transform applies to everything drawn,
	# so scrolling right offsets things to the left, hence the '-' to get the world position.
	# Same with zoom so we divide by the scale.
	var min_pos = -ctrans.get_origin() / ctrans.get_scale()
	
	# The maximum edge is obtained by adding the rectangle size.
	# Because it's a size it's only affected by zoom, so divide by scale too.
	var view_size = get_viewport_rect().size / ctrans.get_scale()
	# var max_pos = min_pos + view_size
	
	# Note: rotation is not taken into account here. An improvement would be
	# to use the inverse transform instead of this.
	
	return min_pos + (0.5 * view_size)


