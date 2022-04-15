extends RigidBody2D
class_name Coin

const money_particle_scene = preload("hud/money_particle.tscn")
const kaching_sfx_scene = preload("coin_kaching_sfx.tscn")

func _ready():
	$animated_sprite.play()

func _on_pickup_body_entered(_body):
	if $iframes.is_stopped():
		# global.coin_count += 1
		for _i in range(10):
			var particle = money_particle_scene.instance()
			particle.velocity = Vector2.RIGHT.rotated(rand_range(-PI, PI)) * rand_range(64, 128)
			global.current_cycle.get_world().add_child(particle)
			particle.global_position = global_position
		
		var kaching_sfx = kaching_sfx_scene.instance()
		global.current_cycle.get_world().add_child(kaching_sfx)
		kaching_sfx.global_position = global_position
		
		queue_free()

func _on_coin_body_entered(_body):
	if 100 < linear_velocity.length():
		$ding_sfx.pitch_scale = rand_range(0.8, 1.2)
		$ding_sfx.play()

func _on_iframes_timeout():
	for body in $pickup.get_overlapping_bodies():
		_on_pickup_body_entered(body)

func slipperoni():
	physics_material_override.friction = 0

func double_slipperoni():
	collision_mask = 0
