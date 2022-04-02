extends Sprite


func _ready():
	if randf() < 0.5:
		flip_h = true
