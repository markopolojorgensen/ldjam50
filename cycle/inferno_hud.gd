extends Node2D

onready var cycle = global.current_cycle

func _process(_delta):
	if 30 <= cycle.cycle_time:
		return
	
	var position_weight = clamp(cycle.cycle_time / 30.0, 0, 1)
	for sprite in get_children():
		sprite.play()
		(sprite as AnimatedSprite).offset.y = lerp(-100, 0, position_weight)
	
	

