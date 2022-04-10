extends Node2D
class_name NPC

func _ready():
	global.music.connect("beat", self, "beat")

func beat():
	pass

