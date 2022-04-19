extends Area2D

export(bool) var use_base_music = true
export(String) var which = "left"

func _on_safe_house_body_entered(_body):
	global.current_cycle.countdown_active = false
	if use_base_music:
		global.current_safehouse = which # hahaha this is a bad coding practice
		global.music.enter_base()

func _on_safe_house_body_exited(_body):
	global.current_cycle.countdown_active = true
	if use_base_music:
		global.music.leave_base()



