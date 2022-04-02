extends Node

# save file stuff
var pickups_acquired = []

# end save file stuff


var current_cycle


func get_total_cycle_time():
	return 5 + (30 * pickups_acquired.size())

func hourglass_picked_up(id):
	pickups_acquired.append(id)
	current_cycle.cycle_time += 30
	current_cycle.added_time()
