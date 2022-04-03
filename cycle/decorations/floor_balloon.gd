extends Sprite


func _ready():
	frame = randi() % 8
	rotation += rand_range(-PI/16, PI/16)
	
	if randf() < 0.5:
		flip_v = true
