extends Position2D

export(PackedScene) var scene
export(bool) var return_to_spawn_point = true
var spawned_thing

func reset():
	if not return_to_spawn_point:
		return
	
#	print("spawner %s is resetting" % name)
	if spawned_thing != null and is_instance_valid(spawned_thing):
		if spawned_thing.has_method("teleport"):
#			print("  teleporting spawned thing %s" % spawned_thing.name)
			spawned_thing.teleport(global_position)
		else:
			print("  positioning spawned thing")
			spawned_thing.global_position = global_position
	else:
		if spawned_thing == null:
			pass
			# print("  spawned thing is null")
		elif not is_instance_valid(spawned_thing):
			# print("  spawned thing is bad instance?")
			spawned_thing = null

# remember to call_deferred
func spawn():
	spawned_thing = scene.instance()
	global.current_cycle.get_world().add_child(spawned_thing)
	spawned_thing.global_position = global_position
