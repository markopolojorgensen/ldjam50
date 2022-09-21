extends Node2D

export(NodePath) var body_path
onready var body : RigidBody2D = get_node(body_path)

export(bool) var active = true

const framerate = 60
var deceleration = 0.10

var lookahead = 0.1 # in seconds

func _physics_process(delta):
	if not active:
		return
	
	for i in range(get_child_count()):
		var ray : RayCast2D = get_child(i)
		if ray.is_colliding():
			# so we could just slow down in the opposite direction of movement:
			# body.apply_central_impulse(body.linear_velocity * -1 * delta * framerate * deceleration)
			
			# but we can do better by only slowing down in the direction of the collision
			# $normal_ray.cast_to = $ray.get_collision_normal() * 20
			# god I love vector projection
			var lv_collision_component = body.linear_velocity.project(-1 * ray.get_collision_normal())
			body.apply_central_impulse(lv_collision_component * -1 * delta * framerate * deceleration)
	
	global_rotation = 0
	# in the next lookahead seconds of travel, will we hit a wall?
	for i in range(get_child_count()):
		var ray : RayCast2D = get_child(i)
		ray.cast_to = (body as RigidBody2D).linear_velocity * max(delta, lookahead)
		ray.cast_to.y = clamp(ray.cast_to.y, -INF, 20) # fall ray already taking care of this i hope





