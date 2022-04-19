extends MarginContainer

onready var game = find_parent("game")

func _enter_tree():
	call_deferred("fancy_focus")

func fancy_focus():
	find_node("tutorial_button").grab_focus()

func _on_tutorial_button_pressed():
	game.swap_to("tutorial")

func _on_start_game_button_pressed():
	game.swap_to("cycle")

func _on_toggle_fullscreen_pressed():
	OS.window_fullscreen = not OS.window_fullscreen






