extends Node


# time remaining in the current cycle
var cycle_time = 30
var is_cycle_ended = false
var countdown_active = true
var time_recovery_rate_slow = 2
var time_recovery_rate_fast = 40

onready var camera = find_node("camera")
onready var level = $world/level
onready var fleeing_player = preload("player/fleeing_player.tscn").instance()

func _enter_tree():
	global.current_cycle = self

func _ready():
	pass
#	cycle_time = float(global.get_total_cycle_time())
	fleeing_player.connect("arrived", self, "respawn_player")

func _process(delta):
	if countdown_active:
		cycle_time -= delta
		
		if cycle_time <= 0:
			end_cycle_now()
	elif not countdown_active and cycle_time < global.get_total_cycle_time():
		# we're in a safe zone, recover time
		var time_weight = get_cycle_time_weight()
		var time_recovery_rate
		if time_weight < 0.5:
			time_recovery_rate = lerp(time_recovery_rate_slow, time_recovery_rate_fast, time_weight)
		else:
			time_recovery_rate = lerp(time_recovery_rate_fast, time_recovery_rate_slow, time_weight)
		cycle_time = clamp(cycle_time + delta * time_recovery_rate, 0, global.get_total_cycle_time())

func add_time(amount):
	cycle_time += amount
	$hud.find_node("bonus_time_label").go(amount)

func end_cycle_now():
	if is_cycle_ended:
		return
	
	is_cycle_ended = true
	
	match global.current_safehouse:
		"left":
			fleeing_player.destination = $world/spawn_position_left.global_position
		"right":
			fleeing_player.destination = $world/spawn_position_right.global_position
	level.add_child(fleeing_player)
	fleeing_player.global_position = global.current_player.global_position
	# fleeing_player.teleport_to = global.current_player.global_position
	level.remove_child(global.current_player)
	camera.focus = fleeing_player
	
#	if not is_cycle_ended:
#		is_cycle_ended = true
#		emit_signal("cycle_ended")

func respawn_player():
	call_deferred("actually_respawn_player")

func actually_respawn_player():
	if not is_cycle_ended:
		return
	
	level.add_child(global.current_player)
	global.current_player.linear_velocity = Vector2()
	global.current_player.global_position = fleeing_player.global_position
	level.remove_child(fleeing_player)
	camera.focus = global.current_player
	
	$player_respawn_sfx.play()
	
	is_cycle_ended = false

func get_world():
	return $world

func get_hud_top_left():
	return $hud/inferno_hud.get_global_transform_with_canvas().origin

# returns float between 0 and 1
# 1 means all the time in the world
# 0 means no time left
#
# called by disco ball
func get_cycle_time_weight():
	return clamp(cycle_time / global.get_total_cycle_time(), 0, 1)

func get_ultra_cycle_time_weight():
	return clamp(cycle_time / 300.0, 0, 1)

func get_camera():
	return camera
