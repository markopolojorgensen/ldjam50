extends Node2D

onready var hud = find_node("order_station_hud")
onready var store_grid = find_node("store_grid")
onready var back_button = find_node("back_button")
var is_active = false

func _ready():
	hud.hide()
	back_button.connect("pressed", self, "hide_store_menu")

func _process(_delta):
	if $player_proximity_detector.is_player_near():
		$sprite.frame = 1
	else:
		$sprite.frame = 0

func _unhandled_input(event):
	if event.is_action_pressed("cycle_talk") and $player_proximity_detector.is_player_near() and not is_active:
		is_active = true
		get_tree().set_input_as_handled()
		hud.pause_mode = PAUSE_MODE_PROCESS
		pause_mode = Node.PAUSE_MODE_PROCESS
		hud.show()
		$store_open.play()
		get_tree().paused = true
		store_grid.fancy_update()
		regrab_store_focus()
	elif event.is_action_pressed("ui_cancel") and hud.is_visible_in_tree():
		hide_store_menu()

func hide_store_menu():
	is_active = false
	$store_close.play()
	hud.hide()
	get_tree().paused = false
	hud.pause_mode = PAUSE_MODE_INHERIT
	pause_mode = Node.PAUSE_MODE_INHERIT

func regrab_store_focus():
	var focus_grabbed = false
	for child in store_grid.get_children():
		if child.has_method("grab_focus") and not child.disabled:
			child.grab_focus()
			focus_grabbed = true
			break
	if not focus_grabbed:
		back_button.grab_focus()

