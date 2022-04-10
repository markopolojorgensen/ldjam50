extends Button

func _ready():
	connect("focus_entered", self, "focus_entered")

func focus_entered():
	$focus_sfx.pitch_scale = rand_range(0.8, 0.9)
	$focus_sfx.play()
