extends Node2D

var node_names = [
	"npcs",
	"secrets",
	"spawn_trigger",
	"pickups",
	"decoration_v_locked",
	"decorations",
]

func _ready():
	for node_name in node_names:
		if has_node(node_name):
			get_node(node_name).show()



















