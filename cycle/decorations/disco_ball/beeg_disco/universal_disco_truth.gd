extends AnimatedSprite


func _ready():
	play()
	var duration = lerp(2, 5, global.rand_normal())
	var scale_dest = lerp(5, 10, global.rand_normal())
	var opacity_start = lerp(0.2, 0.4, global.rand_normal())
	$tween.interpolate_property(self, "scale", Vector2(0.9, 0.9), Vector2(scale_dest, scale_dest), duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(self, "modulate", Color(1,1,1,opacity_start), Color(1,1,1,0.1), duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()

