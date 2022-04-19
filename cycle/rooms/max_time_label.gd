extends Label

func _enter_tree():
	hourglass_picked_up()

func _ready():
	add_to_group("hourglass_pickup_listeners")

func hourglass_picked_up():
	var time_left = global.get_total_cycle_time()
	var minutes = int(floor(time_left / 60.0))
	var seconds = int(floor(time_left)) % 60
	var time_text
	if time_left <= 0:
		time_text = "00:00"
	else:
		time_text = "%02d:%02d" % [minutes, seconds]
	
	text = "Current max: %s" % time_text

