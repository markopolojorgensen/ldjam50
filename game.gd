extends Node

func _unhandled_input(event):
	if event.is_action_pressed("instaquit"):
		get_tree().set_input_as_handled()
		get_tree().quit()
	elif event.is_action_pressed("toggle_fullscreen"):
		get_tree().set_input_as_handled()
		OS.window_fullscreen = not OS.window_fullscreen


