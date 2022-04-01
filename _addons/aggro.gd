class_name Aggro
extends Area2D

# also see http://kidscancode.org/blog/2018/03/godot3_visibility_raycasts/

# don't forget to set up collision layers appropriately
#   raycast needs to collide with scenery layer and aggroing things layer
#   I think you can have scenery and aggroing things on the same layer, but I've not tested it
#   aggro needs to collide with things that trigger aggro
# don't forget to add triggers_aggro() to bodies you want to trigger aggro
# don't forget to add a shape for the aggro and set the raycast path (and enable the raycast)
#
# by default, this node always sets its global rotation to 0


signal aggro(entity)
signal aggro_lost(entity)

# can't instantiate scenes via plugin, so you have to supply your own raycast node
# it's fine to add it as a child of the aggro node.
export(NodePath) var raycast_path
onready var raycast : RayCast2D

# everything within range, regardless of sight
var potential_targets = []

# Todo: support aggroing multiple targets!
var target
var aggro_active = false

# interval between updates, for performance
export(float) var min_interval = 0.3
export(float) var max_interval = 1

export(bool) var respect_parent_rotation = false

# freeze if you're reparenting or pulling other tree shenanigans
# freezing prevents the loss & regain of aggro when the area2d shape gets temporarily orphaned
var frozen = false

export(bool) var debug = false

func _ready():
	raycast = get_node(raycast_path)
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exited")
	# start interval loop
	_on_update_interval_timeout()

func _process(_delta):
	if not respect_parent_rotation:
		global_rotation = 0
	raycast.global_rotation = 0
	
	# hack to force area to recognize static bodies
	position = position
	
#	if is_instance_valid(target):
#		$label.text = "is_colliding: %s" % str(raycast.is_colliding())
#		$label2.text = "collider matches: %s" % str(raycast.get_collider() == target)
#	else:
#		$label.text = "no target"
#		$label2.text = "no target"

func update_target():
#	print("updating aggro")
#	print("  potential targets:")
#	print(potential_targets)
#	if target != null:
#		print("  current target: %s" % target.name)
#	else:
#		print("  no current target")
	
	if not respect_parent_rotation:
		global_rotation = 0
	raycast.global_rotation = 0
	
	(raycast as RayCast2D).enabled = true
	if is_instance_valid(target):
		var target_in_sight = can_see(target)
		if not aggro_active and target_in_sight:
			emit_signal("aggro", target)
			aggro_active = true
		elif aggro_active and not target_in_sight:
			emit_signal("aggro_lost", target)
			aggro_active = false
	
	if not aggro_active:
		for thing in potential_targets:
			if can_see(thing):
				target = thing
	
	(raycast as RayCast2D).enabled = false
	
#	if target != null:
#		print("  current target: %s" % target.name)
#	else:
#		print("  no current target")
#	print("done updating aggro")

func can_see(thing):
	if not is_instance_valid(thing):
		return false
	
	if "cloaked" in thing and thing.cloaked:
		return false
	
	# global_rotation = 0
	
	var aggro_point = thing.global_position
	if thing.has_node("aggro_point"):
		aggro_point = thing.get_node("aggro_point").global_position
	raycast.cast_to = aggro_point - global_position
	raycast.force_raycast_update()
	
	# normally, if we can see something, we expect to be colliding, and colliding with the thing
	# however, sometimes the raycast misses the thing we point it at
	# this happens more often the smaller the collision shape gets
	# also probably related to the relative speeds
	#   (or the speed at which the raycast has to sweep an angle? I'm not sure)
	# anyway, the point is if the raycast isn't colliding with anything,
	#   that also means we have a clear line of sight to the thing
	return (not raycast.is_colliding()) or (raycast.is_colliding() and raycast.get_collider() == thing)

func body_entered(body):
	if body.has_method("triggers_aggro") and body.triggers_aggro() and not frozen:
		if not potential_targets.has(body):
			potential_targets.append(body)

func body_exited(body):
	if body.has_method("triggers_aggro") and body.triggers_aggro() and not frozen:
		if potential_targets.has(body):
			potential_targets.remove(potential_targets.find(body))
		
		if target == body:
			if aggro_active:
				emit_signal("aggro_lost", target)
				aggro_active = false
			target = null

func _on_update_interval_timeout():
	update_target()
	$update_interval.wait_time = rand_range(min_interval, max_interval)
	$update_interval.start()

# boolean for if there's a target we can see
func is_active():
	# FIXME: target gets freed
	#  (I think this already got fixed?)
	return aggro_active and is_instance_valid(target) and target.is_inside_tree()

