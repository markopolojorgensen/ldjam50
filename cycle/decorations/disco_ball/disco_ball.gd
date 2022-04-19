extends AnimatedSprite

export(bool) var always_there = false

# 120 frames, 60 fps -> 1 pulse every 2 seconds
var pulses_per_second = 0.75

onready var game = find_parent("game")

func _enter_tree():
	if always_there and has_node("decoration_purchase_checker"):
		$decoration_purchase_checker.queue_free()

func _ready():
	play()
	$glow.play()
	$glow2.play()
	$glow3.play()
	game.connect("beat", self, "beat")
	
	if always_there:
		show()

func beat():
	$glow.frame = 0
	$glow2.frame = 0
	$glow3.frame = 0
	
	if game.bpm_track != null:
		# we want one pulse per beat
		var bpm = game.bpms[game.bpm_track.name]
		var beats_per_second = bpm / 60.0
		var speed_scale = beats_per_second / pulses_per_second
		# print("disco ball | speed scale: %.1f |" % speed_scale)
		$glow.speed_scale = speed_scale
		$glow2.speed_scale = speed_scale
		$glow3.speed_scale = speed_scale
	else:
		$glow.speed_scale = 1
		$glow2.speed_scale = 1
		$glow3.speed_scale = 1

func _process(_delta):
	var time_weight = global.current_cycle.get_cycle_time_weight()
	speed_scale = lerp(0.1, 4, time_weight)
	$glow.modulate.a = lerp(0.1, 1, time_weight)
	$glow2.modulate.a = lerp(0.05, 0.5, time_weight)
	$glow3.modulate.a = lerp(0.01, 0.25, time_weight)












