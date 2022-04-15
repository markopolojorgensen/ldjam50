extends NPC

func beat():
	.beat()
	$sprite_animation_player.play("thump")

func _process(_delta):
	if $player_proximity_detector.is_player_near():
		$animated_sprite.play("highlighted")
	else:
		$animated_sprite.play("default")

func activate():
	.activate()
	








