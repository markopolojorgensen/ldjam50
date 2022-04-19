extends Node2D

export(bool) var look_right = false

var beat_counter = 0

var width = 32

func _ready():
	global.music.connect("beat", self, "beat")
	if look_right:
		scale.x = -1

func beat():
	$animation_player.play("beat")
#	beat_counter += 1
#	if (beat_counter % 2) == 0:
#		$animation_player.play("beat")
#	else:
#		$animation_player.play("offbeat")










