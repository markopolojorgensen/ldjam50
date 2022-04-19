extends Area2D

const time_particle_scene = preload("hud/time_particle.tscn")
export(int) var id = 1

func _ready():
	connect("body_entered", self, "_on_hourglass_pickup_body_entered")
	if id in global.pickups_acquired:
		queue_free()

func _on_hourglass_pickup_body_entered(_body):
	if not id in global.pickups_acquired:
		global.hourglass_picked_up(self)
		hourglass_picked_up()
		get_tree().call_group("hourglass_pickup_listeners", "hourglass_picked_up")
		print("hourglass pickup %s %d acquired" % [name, id])
	else:
		print("  hourglass pickup %s %d already acquired?!" % [name, id])
	queue_free()

func hourglass_picked_up():
	for _i in range(global.time_per_hourglass):
		var time_particle = time_particle_scene.instance()
		time_particle.velocity = Vector2.RIGHT.rotated(rand_range(-PI, PI)) * rand_range(64, 128)
		global.current_cycle.get_world().add_child(time_particle)
		time_particle.global_position = global_position
