extends Label

onready var cycle = global.current_cycle

func _process(_delta):
	if not is_instance_valid(cycle):
		return
	
	var time_left = cycle.cycle_time
	var minutes = int(floor(time_left / 60.0))
	var seconds = int(floor(time_left)) % 60
	
	if time_left <= 0:
		text = "00:00"
	else:
		text = "%02d:%02d" % [minutes, seconds]
	
	
	
