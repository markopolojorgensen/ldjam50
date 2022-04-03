extends Area2D


func is_player_near():
	return 1 <= get_overlapping_bodies().size()


