extends Label

func _enter_tree():
	piggybank_picked_up()

func _ready():
	add_to_group("pickup_listeners")

func piggybank_picked_up():
	text = "%d/%d" % [global.piggybank_pickups_acquired.size(), 5]

