extends Area2D

const coin_scene = preload("coin.tscn")

export(int) var id = 1

func _ready():
	connect("body_entered", self, "_on_pickup_body_entered")
	if id in global.piggybank_pickups_acquired:
		queue_free()

func _on_pickup_body_entered(_body):
	if not id in global.piggybank_pickups_acquired:
		global.piggybank_pickups_acquired.append(id)
		call_deferred("picked_up")
	else:
		print("pickup %s %d already acquired?!" % [name, id])
	queue_free()

func picked_up():
	for _i in range(10):
		var coin = coin_scene.instance()
		var room = find_parent("room")
		if room == null:
			print("piggybank can't find room?!")
			breakpoint
			queue_free()
		else:
			room.add_child(coin)
			coin.global_position = global_position
			coin.apply_central_impulse(Vector2.UP.rotated(rand_range(-PI/2, PI/2)) * 200)











