extends Node2D

onready var cycle = global.current_cycle

func _ready():
	show()

func _process(_delta):
	if global.has_won:
		hide()
		return
	
	var position_weight = clamp(cycle.cycle_time / 20.0, 0, 1)
	for sprite in get_children():
		sprite.play()
		(sprite as AnimatedSprite).offset.y = lerp(-100, 0, position_weight)

