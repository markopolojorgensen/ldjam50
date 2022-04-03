extends Node2D

var activated = false

func _process(_delta):
	if activated:
		return
	
	if $player_proximity_detector.is_player_near():
		$sprite.frame = 1
	else:
		$sprite.frame = 0

func _unhandled_input(event):
	if event.is_action_pressed("jump") and $player_proximity_detector.is_player_near():
		if not activated:
			activated = true
			get_tree().set_input_as_handled()
			$sprite.frame = 2
			global.current_cycle.end_cycle_now()


