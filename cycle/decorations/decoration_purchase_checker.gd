extends Node

# must match the config in order_station
export(String) var decoration_name = "fish"

func _enter_tree():
	fancy_update()

func fancy_update():
	if decoration_name in global.items_purchased:
		get_parent().show()
	else:
		get_parent().hide()

func _ready():
	add_to_group("decorations")
	add_to_group("store_listeners")

func bought_item():
	fancy_update()

func new_item(item_name):
	if item_name == decoration_name:
		get_parent().show()

