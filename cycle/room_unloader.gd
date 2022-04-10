extends Node2D

export(PackedScene) var room_scene
var room

func _ready():
	room = room_scene.instance()
	$visibility_notifier_2d.connect("screen_entered", self, "do_load")
	$visibility_notifier_2d.connect("screen_exited", self, "do_unload")

func do_load():
	call_deferred("actually_do_load")

func actually_do_load():
	# print("%s adding room to tree" % name)
	add_child(room)
	room.position = Vector2()

func do_unload():
	call_deferred("actually_do_unload")

func actually_do_unload():
	# print("%s removing room from tree" % name)
	remove_child(room)

