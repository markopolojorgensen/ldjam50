extends TextureButton

var item_name = "fish" 
var cost = -1

func _ready():
	connect("pressed", self, "pressed")
	connect("focus_entered", self, "focus_entered")

func fancy_update():
	if item_name.to_lower() in global.items_purchased:
		focus_mode = Control.FOCUS_NONE
		disabled = true
	else:
		focus_mode = Control.FOCUS_ALL
		disabled = false

func focus_entered():
	$focus_sfx.pitch_scale = rand_range(0.8, 0.9)
	$focus_sfx.play()

func pressed():
	if cost <= global.currency and not disabled:
		global.currency -= cost
		global.buy_item(item_name)
		get_tree().call_group("store_listeners", "bought_item")
	elif not disabled and global.currency < cost:
		get_tree().call_group("store_listeners", "cant_afford_it")

func set_textures(normal, highlight, bought):
	texture_normal = normal
	texture_focused = highlight
	texture_disabled = bought

func set_item_name(new_item_name):
	item_name = new_item_name
	$item_name.text = item_name

func set_cost(new_cost):
	cost = new_cost
	$cost.text = "%s$" % str(new_cost)

func set_description(new_description):
	$effect.text = new_description

