extends Label

func _enter_tree():
	hourglass_picked_up()

func _ready():
	add_to_group("hourglass_pickup_listeners")

func hourglass_picked_up():
	text = "%d/%d" % [global.pickups_acquired.size(), 9]

