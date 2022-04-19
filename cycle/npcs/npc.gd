extends Node2D
class_name NPC

onready var dialogue_label = find_node("dialogue_label")

# can be spoken to
var activatable = true

func _ready():
	global.music.connect("beat", self, "beat")
	$player_proximity_detector.connect("body_entered", self, "player_entered")
	$player_proximity_detector.connect("body_exited", self, "player_exited")
	# hide_dialogue()
	$z_index.modulate = Color(1,1,1,0)

func beat():
	pass

func player_entered(_player):
	pass

func player_exited(_player):
	pass

func activate():
	pass

func _unhandled_input(event):
	if not activatable:
		return
	
	if event.is_action_pressed("cycle_talk") and $player_proximity_detector.is_player_near():
		get_tree().set_input_as_handled()
		activate()

func show_dialogue(text):
	# print("showing dialogue: %s" % text)
	dialogue_label.bbcode_text = "[center]%s[/center]" % text
	$text_animation_player.play("fade_in_text")
	$open_sfx.play()
	$dialogue_duration.start()

func hide_dialogue():
	# print($text_animation_player.get_animation_list())
	$text_animation_player.play_backwards("fade_in_text")
	$close_sfx.play()
	$dialogue_duration.stop()

func is_showing_dialogue():
	return ($z_index.modulate.a != 0)

func _on_dialogue_duration_timeout():
	if is_showing_dialogue():
		hide_dialogue()



















