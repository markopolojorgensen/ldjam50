extends Area2D

export(float) var gravity_amount = -1

func _on_gravity_zone_body_entered(body):
	if body.has_method("adjust_gravity"):
		body.adjust_gravity(gravity_amount)

func _on_gravity_zone_body_exited(body):
	if body.has_method("adjust_gravity"):
		body.adjust_gravity(-gravity_amount)
