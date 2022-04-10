extends Area2D

var direction = "left"

var ar := AnimationRandomizer.new()

var velocity := Vector2()

func _enter_tree():
	ar.randomly_flip_v = true
	ar.sprite = $animated_sprite
	
	ar.play_random_animation()
	
	if direction == "right":
		$animated_sprite.flip_h = true
		$animated_sprite.position.x *= -1
		$collision_shape_2d.position.x *= -1

func _ready():
	for body in get_overlapping_bodies():
		_on_paunch_body_entered(body)

func _physics_process(delta):
	position += velocity * delta
	velocity -= velocity * delta

func _on_lifetime_timeout():
	queue_free()

func _on_paunch_body_entered(body):
	if not $active_time.is_stopped() and body.has_method("paunched"):
		body.paunched(self)
