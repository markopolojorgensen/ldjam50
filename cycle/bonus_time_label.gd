extends Label

var current_amount = 0

func _ready():
	modulate = Color(1,1,1,0)


func go(amount):
	current_amount += amount
	text = "+%d" % current_amount
	
	var start_color  = Color(1,1,1,0.7)
	var middle_color = Color.white
	var end_color    = Color(1,1,1,0)
	var start_pos  = Vector2(36, 8)
	var middle_pos = Vector2(36, 16)
	var end_pos    = Vector2(36, 0)
	var duration = 0.2
	$tween.stop_all()
	$tween.remove_all()
	$tween.interpolate_property(self, "modulate", start_color,  middle_color, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(self, "rect_position", start_pos, middle_pos, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(self, "modulate", middle_color,  end_color, duration * 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, duration * 4)
	$tween.interpolate_property(self, "rect_position", middle_pos, end_pos, duration * 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, duration * 4)
	$tween.start()

func _on_tween_tween_all_completed():
	current_amount = 0




















