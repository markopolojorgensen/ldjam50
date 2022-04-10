extends Node

# save file stuff
var pickups_acquired = [] # hourglasses
var piggybank_pickups_acquired = []
var currency = 1000.0
var items_purchased = []

# end save file stuff

const time_per_hourglass = 10

var current_cycle
var current_player

var rng = RandomNumberGenerator.new()

var music
var game

var has_won = false

func get_total_cycle_time():
	return 30 + (time_per_hourglass * pickups_acquired.size())

func hourglass_picked_up(hourglass):
	pickups_acquired.append(hourglass.id)
	# current_cycle.cycle_time += 30
	# current_cycle.added_time()

func buy_item(item_name : String):
	item_name = item_name.to_lower()
	if item_name in items_purchased:
		return
	
	items_purchased.append(item_name)
	get_tree().call_group("decorations", "new_item", item_name)


# returns a number between 0 and 1
# the numbers follow a normal distribution where 0.5 is average
# std deviation is 0.16667
# 0 and 100 are very unlikely (but still possible)
#
# lerp(-10, 10, global_util.rand_normal()) -> random number from -10 to 10 that is mostly around 0
func rand_normal():
	return clamp(rng.randfn(0.5, 0.16667), 0.0, 1.0)

func pick_random_from_list(list):
	var i = randi() % list.size()
	return list[i]


