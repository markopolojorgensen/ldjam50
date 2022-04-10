extends Area2D


func _on_safe_house_body_entered(_body):
	global.current_cycle.countdown_active = false
	global.music.enter_base()

func _on_safe_house_body_exited(_body):
	global.current_cycle.countdown_active = true
	global.music.leave_base()



