extends Node

const cycle_scene = preload("cycle/cycle.tscn")
var current_cycle

func _ready():
	create_new_cycle()

func cycle_ended():
	print("resetting cycle")
	$cycle_reset_animation_player.play("reset")

func create_new_cycle():
	if is_instance_valid(current_cycle):
		current_cycle.queue_free()
	current_cycle = cycle_scene.instance()
	global.current_cycle = current_cycle
	add_child(current_cycle)
	current_cycle.connect("cycle_ended", self, "cycle_ended")

func _unhandled_input(event):
	if event.is_action_pressed("instaquit"):
		get_tree().set_input_as_handled()
		get_tree().quit()
	elif event.is_action_pressed("toggle_fullscreen"):
		get_tree().set_input_as_handled()
		OS.window_fullscreen = not OS.window_fullscreen


