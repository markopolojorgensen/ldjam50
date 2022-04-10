extends NPC

var beat_count = 0
var left = true

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
		$sprite.frame = 0
	else:
		$sprite.frame = 2

func _on_half_beat_interval_timeout():
	var flip = false
	if beat_count in [3, 7]:
		flip = true
	
	if (left and not flip) or (not left and flip):
		$sprite.frame = 1
	else:
		$sprite.frame = 3
