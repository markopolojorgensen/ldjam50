extends RigidBody2D

var fading_out = false

func _ready():
	var starting_frame = (randi() % 10) * 18
	$tween.interpolate_property($sprite, "frame", starting_frame, starting_frame + 17, 3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()

func _physics_process(delta):
#	if $ray_cast_2d.is_colliding():
#		var point = $ray_cast_2d.get_collision_point()
#		var here_to_collision = point - global_position
#		var aligned_component = linear_velocity.project(here_to_collision)
#		apply_central_impulse(-1 * aligned_component * mass * 0.9)
	
	$ray_cast_2d.global_rotation = 0
	$ray_cast_2d.cast_to = linear_velocity * delta * 3


func _on_lifetime_timeout():
	if fading_out or $tween.is_active():
		return
	fading_out = true
	$tween.remove_all()
	$tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
	yield($tween, "tween_completed")
	queue_free()


func _on_shrapnel_body_entered(_body):
	if 100 < linear_velocity.length():
		$sfx.pitch_scale = rand_range(0.9, 1.1)
		$sfx.play()





