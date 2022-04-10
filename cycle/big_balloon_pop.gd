extends AudioStreamPlayer2D


func _ready():
	pitch_scale = rand_range(0.9, 1.1)
	$squak.pitch_scale = rand_range(0.9, 1.1)

func _on_lifetime_timeout():
	queue_free()




