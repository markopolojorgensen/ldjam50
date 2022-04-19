extends Node2D

export(String) var store_item_name = "party supplies"

var platform

func _enter_tree():
	call_deferred("fancy_update")

func _ready():
	add_to_group("store_listeners")
	platform = $platform

func bought_item():
	call_deferred("fancy_update")

func fancy_update():
	if store_item_name in global.items_purchased:
		# $sprite.hide()
		$label.text = "Decoration Acquired"
		if not has_node("platform"):
			add_child(platform)
	else:
		# $sprite.show()
		$label.text = "Missing Decoration"
		$sprite.play()
		if has_node("platform"):
			remove_child(platform)

