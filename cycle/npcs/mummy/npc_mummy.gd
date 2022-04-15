extends NPC

var beat_count = 0
var left = true

var hint_phrase = "I'll come to the party once you buy some streamers."
var phrases = [
	"You can trust me. I keep everything under wraps.",
	"Thanks for throwing the party, it's been fun to unwind.",
	"People say I'm all wrapped up in myself, but they just don't see past my outer layers.",
	"You might think I like wrap music, but I'm more into future bass.",
]
var phrase_index = 0

func beat():
	.beat()
	
	var bpm = global.music.get_bpm()
	var beats_per_second = bpm / 60.0
	var seconds_per_beat = 1.0 / beats_per_second
	
	$half_beat_interval.wait_time = seconds_per_beat / 2.0
	if is_inside_tree():
		$half_beat_interval.start()
	
	match beat_count:
		0, 2, 3, 5:
			left = true
		1, 4, 6, 7:
			left = false
	beat_count = (beat_count + 1) % 8
	
	if left:
		if $player_proximity_detector.is_player_near():
			$sprite.frame = 4
		else:
			$sprite.frame = 0
	else:
		if $player_proximity_detector.is_player_near():
			$sprite.frame = 6
		else:
			$sprite.frame = 2

func _on_half_beat_interval_timeout():
	var flip = false
	if beat_count in [3, 7]:
		flip = true
	
	if (left and not flip) or (not left and flip):
		if $player_proximity_detector.is_player_near():
			$sprite.frame = 5
		else:
			$sprite.frame = 1
	else:
		if $player_proximity_detector.is_player_near():
			$sprite.frame = 7
		else:
			$sprite.frame = 3

func activate():
	.activate()
	if not is_showing_dialogue():
		show_dialogue(phrases[phrase_index])
		phrase_index = (phrase_index + 1) % phrases.size()
	else:
		hide_dialogue()

