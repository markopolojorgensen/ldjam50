extends Camera2D

const resolution = Vector2(720, 405)

export(NodePath) var player_path
onready var player = get_node(player_path)

var bias = "center"
var bias_offset = resolution.x * 0.05
var bias_lerp_original
var bias_weight = 0

var horizonal_focus_position

func _ready():
	$left_trigger.position.x = -1 * resolution.x * 0.2
	$right_trigger.position.x = resolution.x * 0.2
	call_deferred("post_ready")

func post_ready():
	bias_lerp_original = global_position.x
	horizonal_focus_position = global_position.x

func _process(_delta):
	if bias == "left":
		horizonal_focus_position = min(horizonal_focus_position, player.global_position.x - bias_offset)
	elif bias == "right":
		horizonal_focus_position = max(horizonal_focus_position, player.global_position.x + bias_offset)
	elif bias == "center":
		if not $tween.is_active():
			start_bias_tween()
		horizonal_focus_position = player.global_position.x
	else:
		horizonal_focus_position = global_position.x
	
#	current_bias_transition_time = clamp(current_bias_transition_time + delta, 0, max_bias_transition_time)
#	var bias_weight = current_bias_transition_time / max_bias_transition_time
	global_position.x = lerp(bias_lerp_original, horizonal_focus_position, bias_weight)
	
	global_position.y = player.global_position.y

func _on_left_trigger_body_entered(_body):
	if bias != "left":
		bias = "left"
	#	current_bias_transition_time = 0
		bias_lerp_original = global_position.x
		start_bias_tween()

func _on_right_trigger_body_entered(_body):
	if bias != "right":
		bias = "right"
	#	current_bias_transition_time = 0
		bias_lerp_original = global_position.x
		start_bias_tween()

func start_bias_tween():
	$tween.stop_all()
	$tween.remove_all()
	$tween.interpolate_property(self, "bias_weight", 0, 1.0, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
#	$tween.interpolate_property(self, "bias_weight", 0, 1.0, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()




