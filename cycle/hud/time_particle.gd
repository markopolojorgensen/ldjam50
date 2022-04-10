extends Sprite

export(String, "time", "money") var particle_type = "time"

var destination

var velocity := Vector2()
var acceleration = 500
var speed = 400

func _ready():
	var starting_frame = (randi() % 10) * 18
	$tween.interpolate_property(self, "frame", starting_frame, starting_frame + 17, 3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$tween.start()

func _process(delta):
	position += velocity * delta
	
	if not $delayed_start.is_stopped():
		return
	
	var camera : Camera2D = get_tree().get_nodes_in_group("camera")[0]
	# used to test if the particle is offscreen
	var alignment_vector
	match particle_type:
		"time":
			destination = camera.get_camera_screen_center() - (get_viewport_rect().size / 2.0)
			alignment_vector = Vector2(1,1)
		"money":
			destination = camera.get_camera_screen_center()
			var resolution : Vector2 = get_viewport_rect().size
			destination.x += resolution.x / 2.0
			destination.y -= resolution.y / 2.0
			alignment_vector = Vector2(-1,1)
	var here_to_there = destination - global_position
	if 0 < here_to_there.normalized().dot(alignment_vector):
		match particle_type:
			"time":
				global.current_cycle.add_time(1)
				get_tree().call_group("time_ding", "play")
			"money":
				global.currency += 0.1
				get_tree().call_group("coin_ding", "play")
		queue_free()
	var desired_velocity = here_to_there.normalized() * speed
	var velocity_diff = desired_velocity - velocity
	var impulse = velocity_diff.normalized() * delta * acceleration
	impulse = impulse.clamped(velocity_diff.length())
	velocity += impulse




