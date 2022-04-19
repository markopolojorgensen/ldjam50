extends Area2D

const coin_scene = preload("coin.tscn")
const sfx_scene = preload("piggy_bank_pickup_sfx.tscn")

onready var room = find_parent("room")

export(int) var id = 1

func _ready():
	connect("body_entered", self, "_on_pickup_body_entered")
	if id in global.piggybank_pickups_acquired:
		queue_free()

func _on_pickup_body_entered(_body):
	if not id in global.piggybank_pickups_acquired:
#		print("piggybank pickup %s %d acquired" % [name, id])
		global.piggybank_pickups_acquired.append(id)
		call_deferred("picked_up")
		get_tree().call_group("pickup_listeners", "piggybank_picked_up")
		print("piggybank pickup %s %d acquired" % [name, id])
	else:
		print("  piggybank pickup %s %d already acquired?!" % [name, id])
	queue_free()

func picked_up():
	var sfx = sfx_scene.instance()
	room.add_child(sfx)
	sfx.global_position = global_position
	
	# spawn coins
	for _i in range(10):
		var coin = coin_scene.instance()
		room.add_child(coin)
		coin.global_position = global_position
		coin.apply_central_impulse(Vector2.UP.rotated(rand_range(-PI/2, PI/2)) * 200)











