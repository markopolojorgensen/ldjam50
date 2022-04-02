extends Sprite

func _ready():
	randomize()
	offset.x += int(round(rand_range(-8, 8)))
	offset.y += int(round(rand_range(-16, 16)))
	
	frame = randi() % 8
	
	$line_2d.add_point(Vector2())
	$line_2d.add_point(offset + Vector2(0, 7))
