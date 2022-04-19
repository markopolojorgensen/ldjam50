extends PathFollow2D

export(String) var key = "a"
export(int) var speed = 100


func _ready():
	find_parent("room").balloon_swarms[key] = self

func _process(delta):
	offset += delta * speed
	offset = fmod(offset, get_parent().curve.get_baked_length())
