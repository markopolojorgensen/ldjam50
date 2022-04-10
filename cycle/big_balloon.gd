extends RigidBody2D

const shrapnel_scene = preload("shrapnel/shrapnel.tscn")
const coin_scene = preload("coin.tscn")
const audio_scene = preload("big_balloon_pop.tscn")

var on_beat = true
var og_altitude

var teleport_destination

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
	for _i in range(30):
		spawn_thing(shrapnel_scene)
	for _i in range(2):
		spawn_thing(coin_scene)
	
	var sfx = audio_scene.instance()
	global.current_cycle.get_world().add_child(sfx)
	sfx.global_position = global_position
	
	queue_free()

func spawn_thing(scene):
	var shrapnel = scene.instance()
	global.current_cycle.get_world().add_child(shrapnel)
	var here_to_there = Vector2.RIGHT.rotated(rand_range(-PI, PI))
	shrapnel.global_position = global_position + (here_to_there * (1 + randi() % 5))
	shrapnel.apply_central_impulse(here_to_there * 600)

func beat():
	if not "music" in global.items_purchased:
		return
	elif not is_inside_tree():
		return
	
	var altitude_diff = og_altitude - global_position.y
	var magnitude
	if altitude_diff < 0:
		# desired altitude is above us
		magnitude = 10
	else:
		var upwards_velocity = clamp(linear_velocity.y, -INF, 0)
		magnitude = (-1 * upwards_velocity) + clamp(altitude_diff * 2, 0, 100)
#		print("altitude diff: %.1f | magnitude: %.1f" % [altitude_diff, magnitude])
	var impulse = Vector2.DOWN * magnitude
	impulse.x = rand_range(-2, 2)
	apply_central_impulse(impulse)

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

















