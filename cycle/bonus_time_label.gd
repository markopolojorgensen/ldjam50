extends Label

func _ready():
	modulate = Color(0,0,0,0)

func go():
	$tween.stop_all()
	$tween.remove_all()
	var from_color = Color(0,0,0,0)
	var to_color   = Color.white
	var from_pos = Vector2(36, 0)
	var to_pos   = Vector2(36, 16)
	var duration = 0.2
	$tween.interpolate_property(self, "modulate", from_color,  to_color, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(self, "rect_position", from_pos, to_pos, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(self, "modulate", to_color,  from_color, duration * 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, duration * 4)
	$tween.interpolate_property(self, "rect_position", to_pos, from_pos, duration * 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, duration * 4)
	$tween.start()








