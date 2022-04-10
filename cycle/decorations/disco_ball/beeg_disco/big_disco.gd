extends AnimatedSprite

const truth_scene = preload("universal_disco_truth.tscn")

var has_won = false

func _ready():
	$area_2d.connect("body_entered", self, "start_spin_up")
	$area_2d.connect("body_exited", self, "stop_spin_up")
	$truth_interval.connect("timeout", self, "spawn_truth")
	$win_timer.connect("timeout", self, "win")
	play()

func start_spin_up(_body):
	$tween.stop_all()
	$tween.remove_all()
	$tween.interpolate_property(self, "speed_scale", speed_scale, 20, 15, Tween.TRANS_QUAD, Tween.EASE_IN)
	$tween.start()
	$win_timer.start()
	spawn_truth()
	global.current_cycle.get_camera().focus = self

func stop_spin_up(_body):
	if $tween.is_inside_tree():
		$tween.stop_all()
		$tween.remove_all()
		$tween.interpolate_property(self, "speed_scale", speed_scale, 0.5, 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$tween.start()
	$truth_interval.stop()
	$win_timer.stop()
	global.current_cycle.get_camera().focus = global.current_player

func spawn_truth():
	var truth = truth_scene.instance()
	add_child(truth)
	var weight = 0
	if $tween.is_active():
		weight = clamp($tween.tell() / $tween.get_runtime(), 0, 1)
		global.current_cycle.add_time(1)
	elif has_won:
		weight = 1.0
	truth.z_index = int(round(lerp(-10, 10, weight)))
	$truth_interval.wait_time = lerp(2, 0.1, weight)
	$truth_interval.start()

func win():
	has_won = true
	global.has_won = true
	get_tree().call_group("win", "on_win")

func _process(_delta):
	if has_won:
		global.current_cycle.add_time(int(round(global.current_cycle.cycle_time * 0.1)))

