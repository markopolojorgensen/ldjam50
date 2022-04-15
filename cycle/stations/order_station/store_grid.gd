extends GridContainer

const widget_scene = preload("store_grid_widget.tscn")

onready var order_station = find_parent("order_station")

func _ready():
	add_to_group("store_listeners")
	
	for child in get_children():
		if child.name != "configuration":
			child.queue_free()
	
	for config in $configuration.get_children():
		var widget = widget_scene.instance()
		widget.set_textures(config.button_texture_normal, config.button_texture_highlighted, config.button_texture_disabled)
		widget.set_item_name(config.store_item_name)
		widget.set_cost(config.cost)
		widget.set_description(config.description)
		add_child(widget)

func bought_item():
	# print("item bought")
	fancy_update()
	order_station.regrab_store_focus()

func fancy_update():
	for child in get_children():
		if child.has_method("fancy_update"):
			child.fancy_update()





