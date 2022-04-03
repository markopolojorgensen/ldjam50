extends Area2D

func _on_safe_house_body_entered(_body):
	global.current_cycle.countdown_active = false

func _on_safe_house_body_exited(_body):
	global.current_cycle.countdown_active = true

