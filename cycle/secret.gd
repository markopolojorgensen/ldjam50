extends Area2D

var activated = false

func _ready():
	connect("body_entered", self, "body_entered")

func body_entered(_body):
	if not activated:
		activated = true
		$tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$tween.start()
		$secret_sfx.play()
		if has_node("boom_lines"):
			$boom_lines.call_deferred("kaboom")




























