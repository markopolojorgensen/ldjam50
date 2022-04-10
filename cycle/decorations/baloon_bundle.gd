extends Sprite

const baloon_scene = preload("baloon.tscn")

func _ready():
	call_deferred("add_baloons")

func add_baloons():
	var baloon_count = 3 + (randi() % 3)
	for _i in range(baloon_count):
		var baloon = baloon_scene.instance()
		add_child(baloon)
		baloon.position = $position_2d.position











