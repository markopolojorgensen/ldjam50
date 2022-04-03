extends Node

# save file stuff
var pickups_acquired = []

# end save file stuff


var current_cycle
var current_player

var rng = RandomNumberGenerator.new()

func get_total_cycle_time():
	return 35 + (30 * pickups_acquired.size())

func hourglass_picked_up(id):
	pickups_acquired.append(id)
	current_cycle.cycle_time += 30
	current_cycle.added_time()

# returns a number between 0 and 1
# the numbers follow a normal distribution where 0.5 is average
# std deviation is 0.16667
# 0 and 100 are very unlikely (but still possible)
#
# lerp(-10, 10, global_util.rand_normal()) -> random number from -10 to 10 that is mostly around 0
func rand_normal():
	return clamp(rng.randfn(0.5, 0.16667), 0.0, 1.0)
