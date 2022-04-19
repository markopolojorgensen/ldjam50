extends Position2D

# this node goes in the bottom right corner of the area to cover in rain

const rain_scene = preload("res://cycle/rain/rain.tscn")

export(int) var horizontal_count = 5
export(int) var vertical_count = 5

func _ready():
	call_deferred("spawn_rain")

func spawn_rain():
	for h in range(horizontal_count):
		for v in range(vertical_count):
			var rain = rain_scene.instance()
			rain.position = position + Vector2(h * 256, v * -256)
			rain.position += Vector2(128, -128)
			get_parent().add_child(rain)
	queue_free()
