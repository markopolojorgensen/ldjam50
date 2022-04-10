extends MarginContainer

#		get_tree().call_group("store_listeners", "cant_afford_it")

onready var og_position = rect_position

func _ready():
	add_to_group("store_listeners")

func _process(_delta):
	if $shake_duration.is_stopped():
		return
	
	# higher = more time left
	var weight = $shake_duration.time_left / $shake_duration.wait_time
	
	rect_position = og_position + (Vector2.RIGHT.rotated(rand_range(-PI, PI)) * lerp(0, 8, weight))

func cant_afford_it():
	$shake_duration.start()
	$cant_afford_it_sfx.play()

func bought_item():
	$bought_item.play()
	$bought_item2.play()


