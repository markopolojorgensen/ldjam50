extends Sprite

var width = 100

func _ready():
	frame = randi() % 3
	if randf() < 0.5:
		flip_h = true
	
	var weight = abs(global.rand_normal() - 0.5) * 2
	var scale_factor = lerp(0.25, 1.0, weight)
	scale = Vector2(scale_factor, scale_factor)
	
	rotation = rand_range(-PI/16, PI/16)
