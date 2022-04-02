extends RigidBody2D

const max_speed = 400
const max_acceleration = 2000

var wants_to_jump = false
var touching_ground = false


func _process(_delta):
	var intended_direction = $intended_direction.get_intended_direction()
	var desired_animation
	
	if intended_direction.x < -0.1:
		desired_animation = "run"
		$animated_sprite.flip_h = true
		var speed_weight = clamp(abs(linear_velocity.x) / max_speed, 0, 1)
		$animated_sprite.speed_scale = lerp(1, 2, speed_weight)
	elif 0.1 < intended_direction.x:
		desired_animation = "run"
		$animated_sprite.flip_h = false
		var speed_weight = clamp(abs(linear_velocity.x) / max_speed, 0, 1)
		$animated_sprite.speed_scale = lerp(0.5, 2, speed_weight)
	elif abs(linear_velocity.x) < 10 and touching_ground:
		desired_animation = "idle"
	
	if wants_to_jump:
		if $animated_sprite.animation == "jump_start":
			$animated_sprite.speed_scale = 1
			if $animated_sprite.frame == 2:
				desired_animation = "jump_loop"
			else:
				desired_animation = "jump_start"
		elif not touching_ground and $animated_sprite.animation == "jump_loop":
			$animated_sprite.speed_scale = 1
			desired_animation = "jump_loop"
	
	if desired_animation != null and $animated_sprite.animation != desired_animation:
		$animated_sprite.play(desired_animation)



func _integrate_forces(state):
	if not touching_ground and $ground_detector.is_colliding() and wants_to_jump:
		start_jump()
	touching_ground = $ground_detector.is_colliding()
	# $label.text = "touching ground: %s" % str(touching_ground)
	
	var intended_direction = $intended_direction.get_intended_direction()
	var max_impulse_magnitude = max_acceleration * state.step
	if 0 < abs(intended_direction.x):
		var horizontal_direction = sign(intended_direction.x)
		var intended_horizontal_speed = horizontal_direction * max_speed
		var horizontal_speed_diff = intended_horizontal_speed - state.linear_velocity.x
		
		var horizontal_impulse = Vector2(horizontal_speed_diff, 0)
		state.apply_central_impulse(horizontal_impulse.clamped(max_impulse_magnitude))
	elif abs(intended_direction.x) <= 0:
		# slow down / stop
		var slow_down_impulse = Vector2(-1 * state.linear_velocity.x, 0).clamped(max_impulse_magnitude)
		state.apply_central_impulse(slow_down_impulse)
	
	if max_speed < state.linear_velocity.length():
		pass
		# TODO: slow down
	
	if wants_to_jump:
		apply_central_impulse(Vector2(0, -300) * state.step)
	
	if $fall_ray.is_colliding() and 20 < linear_velocity.y:
		var speed_diff = 20 - linear_velocity.y
		apply_central_impulse(Vector2(0, speed_diff / 3.0))
	
	$fall_ray.cast_to.y = clamp(linear_velocity.y * state.step * 3, 1.0, INF)

func start_jump():
	apply_central_impulse(Vector2(0, -600))
	$animated_sprite.play("jump_start")


func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		get_tree().set_input_as_handled()
		wants_to_jump = true
		if touching_ground:
			start_jump()
	elif event.is_action_released("jump"):
		get_tree().set_input_as_handled()
		wants_to_jump = false
		if linear_velocity.y < 0:
			apply_central_impulse(Vector2(0, linear_velocity.y * -1.1))














