extends Sprite

export(int) var frame_count = 1

func _ready():
	frame = randi() % frame_count
	
	if randf() < 0.5:
		flip_h = true











