extends Node

signal cycle_ended

# time remaining in the current cycle
var cycle_time
var is_cycle_ended = false
var countdown_active = false

func _ready():
	cycle_time = float(global.get_total_cycle_time())

func _process(delta):
	if not countdown_active:
		return
	
	cycle_time -= delta
	
	if cycle_time <= 0:
		end_cycle_now()

func added_time():
	find_node("bonus_time_label").go()

func end_cycle_now():
	if not is_cycle_ended:
		is_cycle_ended = true
		emit_signal("cycle_ended")

