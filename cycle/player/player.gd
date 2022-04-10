extends RigidBody2D

const max_speed = 300
const max_acceleration = 2000

const initial_jump_magnitude = 500
const continuous_jump_magnitude = 350

var attack_animation = null
var previous_attack_animation = "attack_c"
const attack_impulse_magnitude = 400
const paunch_scene = preload("one_paunch/paunch.tscn")

var wants_to_jump = false
var touching_ground = false

var gravity_multiplier = 1.0
onready var og_gravity = gravity_scale

func _enter_tree():
	global.current_player = self

func _ready():
	global.music.connect("beat", self, "beat")
	$animated_sprite.play("jump_loop")

func _process(_delta):
	var intended_direction = $intended_direction.get_intended_direction()
	var desired_animation
	
	if intended_direction.x < -0.1:
		desired_animation = "run"
		$animated_sprite.flip_h = true
		update_sprite_speed_scale()
	elif 0.1 < intended_direction.x:
		desired_animation = "run"
		$animated_sprite.flip_h = false
		update_sprite_speed_scale()
	elif abs(linear_velocity.x) < 10 and touching_ground:
		$animated_sprite.speed_scale = 1
		if "music" in global.items_purchased:
			desired_animation = "idle_tap"
		else:
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
	
	if attack_animation != null:
		desired_animation = attack_animation
	
	if desired_animation != null and $animated_sprite.animation != desired_animation:
		$animated_sprite.play(desired_animation)

func beat():
	if $animated_sprite.animation == "idle_tap":
		$animated_sprite.frame = 0

func update_sprite_speed_scale():
	var speed_weight = clamp(abs(linear_velocity.x) / max_speed, 0, 1)
	$animated_sprite.speed_scale = lerp(0.5, 2.5, speed_weight)

func _integrate_forces(state):
	# just stopped touching the ground
	if touching_ground and not $ground_detector.is_colliding():
		$coyote_time.start()
	
	# just started touching the ground
	if not touching_ground and $ground_detector.is_colliding():
		$footstep_sfx.play()
		if wants_to_jump and 0 <= state.linear_velocity.y:
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
	
	# fall slightly faster, mostly for zero-g
	if 0.1 < intended_direction.y:
		apply_central_impulse(Vector2.DOWN * state.step * continuous_jump_magnitude * 0.5)
	
	if max_speed < state.linear_velocity.length():
		pass
		# TODO: slow down
	
	if wants_to_jump:
		apply_central_impulse(Vector2(0, -continuous_jump_magnitude) * state.step)
	
	if $fall_ray.is_colliding() and 20 < linear_velocity.y:
		var speed_diff = 20 - linear_velocity.y
		apply_central_impulse(Vector2(0, speed_diff / 3.0))
	
	$fall_ray.cast_to.y = clamp(linear_velocity.y * state.step * 3, 1.0, INF)

func start_jump():
	if $jump_cooldown.is_stopped():
		$jump_cooldown.start()
		apply_central_impulse(Vector2(0, -initial_jump_magnitude))
		$animated_sprite.play("jump_start")
		$jump_sfx.pitch_scale = rand_range(0.9, 1.1)
		$jump_sfx.play()


func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		get_tree().set_input_as_handled()
		wants_to_jump = true
		if (touching_ground or not $coyote_time.is_stopped()) and 0 <= linear_velocity.y:
			start_jump()
	elif event.is_action_released("jump"):
		get_tree().set_input_as_handled()
		wants_to_jump = false
		if linear_velocity.y < 0:
			apply_central_impulse(Vector2(0, linear_velocity.y * -0.9))
	elif event.is_action_pressed("attack") and $attack_duration.is_stopped() and $attack_cooldown.is_stopped():
		# attack triggers buttons, don't set as handled
#		get_tree().set_input_as_handled()
		attack_animation = global.pick_random_from_list(["attack_a", "attack_b", "attack_c"])
		while attack_animation == previous_attack_animation:
			attack_animation = global.pick_random_from_list(["attack_a", "attack_b", "attack_c"])
		previous_attack_animation = attack_animation
		var direction
		if $animated_sprite.flip_h:
			if touching_ground:
				apply_central_impulse(Vector2.LEFT * attack_impulse_magnitude)
			else:
				# go up
				apply_central_impulse(Vector2.LEFT.rotated(PI/8) * attack_impulse_magnitude)
			direction = "left"
		else:
			if touching_ground:
				apply_central_impulse(Vector2.RIGHT * attack_impulse_magnitude)
			else:
				apply_central_impulse(Vector2.RIGHT.rotated(-PI/8) * attack_impulse_magnitude)
			direction = "right"
		$attack_duration.start()
		
		var paunch = paunch_scene.instance()
		paunch.direction = direction
		global.current_cycle.get_world().add_child(paunch)
		var attack_position
		match attack_animation:
			"attack_a":
#				attack_position = $attack_position_a.global_position
				attack_position = $attack_position_a.position
			"attack_b":
#				attack_position = $attack_position_b.global_position
				attack_position = $attack_position_b.position
			"attack_c":
#				attack_position = $attack_position_c.global_position
				attack_position = $attack_position_c.position
		paunch.velocity = Vector2(attack_impulse_magnitude, 0) + Vector2(abs(linear_velocity.x), 0)
		if direction == "left":
			attack_position.x *= -1
			paunch.velocity.x *= -1
		paunch.global_position = global_position + attack_position
#		add_child(paunch)
		
		$attack_sfx.pitch_scale = rand_range(0.9, 1.1)
		$attack_sfx.play()

func _on_attack_duration_timeout():
	attack_animation = null
	$attack_cooldown.start()

func _on_attack_cooldown_timeout():
	pass # Replace with function body.

func _on_animated_sprite_frame_changed():
	if $animated_sprite.animation == "run" and ($animated_sprite.frame == 4 or $animated_sprite.frame == 11) and touching_ground:
		$footstep_sfx.pitch_scale = rand_range(0.8, 1.2)
		$footstep_sfx.play()

func adjust_gravity(amount):
	gravity_multiplier += amount
	gravity_scale = og_gravity * gravity_multiplier


















