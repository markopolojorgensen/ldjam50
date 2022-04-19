extends Label

func _enter_tree():
	fancy_update()

func _ready():
	add_to_group("generic_npcs")

func fancy_update():
	text = "%d/%d Guests" % [global.invited_npcs.size(), 8]

