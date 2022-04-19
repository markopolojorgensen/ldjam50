extends Node2D

const hourglass_scene = preload("hourglass_pickup.tscn")

var spawned = false
export(String) var store_trigger = "hourglass i"
export(int) var hourglass_id = 0

func _enter_tree():
	call_deferred("fancy_update")

func _ready():
	add_to_group("store_listeners")

func bought_item():
	call_deferred("fancy_update")

func fancy_update():
	if not spawned and store_trigger in global.items_purchased:
		spawned = true
		var hourglass = hourglass_scene.instance()
		hourglass.id = hourglass_id
		add_child(hourglass)
		hourglass.position = Vector2()










