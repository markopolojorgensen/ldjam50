extends Position2D

export(PackedScene) var scene
export(bool) var return_to_spawn_point = true
var spawned_thing

onready var room = find_parent("room")
export(String) var balloon_swarm_key

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
	if balloon_swarm_key != null and balloon_swarm_key != "" and "balloon_swarm" in spawned_thing and room.has_method("get_balloon_swarm"):
#		print("setting balloon swarm")
		spawned_thing.balloon_swarm = room.get_balloon_swarm(balloon_swarm_key) 
	room.add_child(spawned_thing)
	spawned_thing.global_position = global_position
