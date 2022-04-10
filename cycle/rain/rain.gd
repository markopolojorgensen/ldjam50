extends AnimatedSprite


func _ready():
	frame = randi() % 120
	play()

