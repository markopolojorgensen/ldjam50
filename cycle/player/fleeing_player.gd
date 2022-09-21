extends RigidBody2D

signal arrived

var destination
var speed = 600

var teleport_to

func _enter_tree():
	# more magic
	# no idea why I have to do this
	$path_2d/path_follow_2d/particles_2d.position = Vector2()

func _ready():
	$animation_player.play("circle")
	$path_2d/path_follow_2d/particles_2d.emitting = true

func _integrate_forces(state):
	if teleport_to != null:
		state.transform.origin = teleport_to
		teleport_to = null
	
	if global_position.distance_to(destination) < 8:
		emit_signal("arrived")
		state.linear_velocity = Vector2()
	else:
		var desired_lv = global_position.direction_to(destination) * speed
		var lv_diff = desired_lv - state.linear_velocity
		apply_central_impulse(lv_diff.clamped(1000 * state.step))
		# position += global_position.direction_to(destination) * speed * state.step

