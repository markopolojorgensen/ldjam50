extends CenterContainer

func _ready():
	show()

func _process(_delta):
	if global.has_won:
		return
	
	var cycle = global.current_cycle
	if not is_instance_valid(cycle):
		return
	
	var time_left = clamp(cycle.cycle_time, 0, INF)
	
	if time_left <= 10:
		show()
		var opacity_weight = 1.0 - clamp(time_left / 10.0, 0, 1)
		modulate = Color(1,1,1, lerp(0, 0.5, opacity_weight))
	else:
		hide()



