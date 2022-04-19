extends Node2D

var balloon_swarms = {}

var node_names = [
	"npcs",
	"secrets",
	"spawn_trigger",
	"pickups",
	"decoration_v_locked",
	"decorations_v_locked",
	"decorations",
	"decorations_foreground",
	"decorations_deep_floor",
	"decorations_ceiling",
	"decorations_floor",
	"decorations_background",
	"decorations_foreground",
]

func _enter_tree():
	call_deferred("spawn_update_balloons")

func spawn_update_balloons():
	if has_node("spawn_trigger"):
		# do big balloon respawn now
		$spawn_trigger._on_spawn_trigger_body_entered(null)

func _ready():
	for node_name in node_names:
		if has_node(node_name):
			get_node(node_name).show()

func get_balloon_swarm(key):
	return balloon_swarms[key]

















