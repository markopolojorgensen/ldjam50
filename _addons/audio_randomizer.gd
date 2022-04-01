class_name AudioRandomizer
extends Node2D

# returns the length of the sound it picks
func play_random_audiostream():
	if get_child_count() <= 0:
		print("audio randomizer with no children?")
		breakpoint
	
	var index = randi() % get_child_count()
	(get_child(index) as AudioStreamPlayer2D).play()
	return (get_child(index) as AudioStreamPlayer2D).stream.get_length()

func is_playing():
	for child in get_children():
		if (child as AudioStreamPlayer2D).is_playing():
			return true
	return false
