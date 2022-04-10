extends Node

# must match the config in order_station
export(String) var decoration_name = "fish"

func _enter_tree():
	if decoration_name in global.items_purchased:
		get_parent().show()
	else:
		get_parent().hide()

func _ready():
	add_to_group("decorations")

func new_item(item_name):
	if item_name == decoration_name:
		get_parent().show()

