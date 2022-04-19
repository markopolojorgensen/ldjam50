extends RigidBody2D

const shrapnel_scene = preload("shrapnel/shrapnel.tscn")
const coin_scene = preload("coin.tscn")
const audio_scene = preload("big_balloon_pop.tscn")

var on_beat = true
var og_altitude

var teleport_destination

var balloon_swarm

onready var room = find_parent("room")

func _ready():
#	if randf() < 0.5:
#		on_beat = true
	global.music.connect("beat", self, "beat")
	call_deferred("post_ready")

func post_ready():
	og_altitude = global_position.y

func _integrate_forces(state):
	if teleport_destination != null:
#		print("      %s is teleporting" % name)
		state.transform.origin = teleport_destination
		teleport_destination = null

func paunched(_paunch):
	call_deferred("go_kaboom")

func go_kaboom():
#	for _i in range(1):
	for _i in range(15):
		spawn_thing(shrapnel_scene)
	for _i in range(2):
		spawn_thing(coin_scene)
	
	var sfx = audio_scene.instance()
	global.current_cycle.get_world().add_child(sfx)
	sfx.global_position = global_position
	
	queue_free()

func spawn_thing(scene):
	var shrapnel = scene.instance()
	room.add_child(shrapnel)
	var here_to_there = Vector2.RIGHT.rotated(rand_range(-PI, PI))
	shrapnel.global_position = global_position + (here_to_there * (1 + randi() % 5))
	shrapnel.apply_central_impulse(here_to_there * 600)

func beat():
	if not "music" in global.items_purchased:
		return
	elif not is_inside_tree():
		return
	
	if balloon_swarm != null and not balloon_swarm.is_inside_tree():
		return
	
	var impulse := Vector2()
	var altitude_diff
	var max_v_magnitude
	if balloon_swarm == null:
		altitude_diff = og_altitude - global_position.y
		impulse.x = rand_range(-2, 2)
		max_v_magnitude = 75
	else:
		max_v_magnitude = 150
		altitude_diff = balloon_swarm.global_position.y - global_position.y
		var h_diff = balloon_swarm.global_position.x - global_position.x
		var desired_h_speed = h_diff * 2
		var h_speed_diff = desired_h_speed - linear_velocity.x
		impulse.x = clamp(h_speed_diff, -100, 100)
	
	if altitude_diff < 0:
		# desired altitude is above us
		impulse.y = 10
	else:
		var desired_v_speed = altitude_diff * 2
		var v_speed_diff = desired_v_speed - linear_velocity.y
		var upwards_velocity = clamp(linear_velocity.y, -INF, 0)
		# magnitude = (-1 * upwards_velocity) + clamp(altitude_diff * 2, 0, 100)
		impulse.y = (-1 * upwards_velocity) + clamp(v_speed_diff, -max_v_magnitude, max_v_magnitude)
#		print("altitude diff: %.1f | magnitude: %.1f" % [altitude_diff, magnitude])
	apply_central_impulse(impulse)
	
	# rotation
	var angle_diff = 0 - rotation
	var desired_angle_velocity = angle_diff * 100
	var angle_velocity_diff = desired_angle_velocity - angular_velocity
	var max_torque = PI * 100
#	print(angle_velocity_diff)
	apply_torque_impulse(clamp(angle_velocity_diff, -max_torque, max_torque))

func _on_jitter_timeout():
	pass
#	if on_beat:
#		var magnitude = 0
#		if linear_velocity.y <= 0:
#			magnitude = (-1 * linear_velocity.y) + 40
#		apply_central_impulse(Vector2.DOWN.rotated(rand_range(-PI/8, PI/8)) * magnitude)
	# on_beat = not on_beat
	# apply_central_impulse(Vector2.DOWN * rand_range(0, 25))

func teleport(dest):
#	print("    %s wants to teleport" % name)
	teleport_destination = dest
	sleeping = false

















