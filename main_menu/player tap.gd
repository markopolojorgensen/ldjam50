extends AnimatedSprite

func _enter_tree():
	call_deferred("reset_timer")

func reset_timer():
	play("default")
	$timer.start()

func _on_timer_timeout():
	play("tap")
