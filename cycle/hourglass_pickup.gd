extends Area2D

export(int) var id = 1

func _on_hourglass_pickup_body_entered(_body):
	if not id in global.pickups_acquired:
		global.hourglass_picked_up(id)
	else:
		print("pickup %d already acquired?!" % id)
	queue_free()


