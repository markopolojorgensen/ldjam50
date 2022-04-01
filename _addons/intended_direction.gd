extends Node2D

# TO USE
# configure InputMap actions appropriately and go to town

export(String) var left_action  = "joystick_left"
export(String) var right_action = "joystick_right"
export(String) var up_action    = "joystick_up"
export(String) var down_action  = "joystick_down"

# always returns a normalized vector
# but remember that (0,0) normalizes to (0,0)
func get_intended_direction():
	var direction = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	
	return direction.normalized()

# since horizontal and vertical both range from 0 to 1, there's
# some weirdness related to the clamping. I don't remember exactly what, sorry.
func get_joystick_intended_direction():
#	var horizontal = Input.get_action_strength(right_action) - Input.get_action_strength(left_action)
#	var vertical = Input.get_action_strength(down_action) - Input.get_action_strength(up_action)
#	var intended_direction = Vector2(horizontal, vertical).clamped(1)
	var intended_direction = Input.get_vector(left_action, right_action, up_action, down_action)
	$sprite.global_rotation = intended_direction.angle()
#	$leftright.global_rotation = 0
#	$leftright.scale = Vector2(horizontal, 0.05)
#	$leftright.global_position = global_position + $leftright.scale * Vector2(32, 0)
#	$updown.global_rotation = 0
#	$updown.scale = Vector2(0.05, vertical)
#	$updown.global_position = global_position + $updown.scale * Vector2(0, 32)
	$length.text = "%.2f" % intended_direction.length()
	return intended_direction

func _process(_delta):
	get_joystick_intended_direction()

