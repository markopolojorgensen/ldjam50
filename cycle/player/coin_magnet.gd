extends Area2D

const grab_scene = preload("streamer_grab.tscn")
var active = false

var coins_being_grabbed = []

const acceleration = 2000

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	var to_remove = []
	for coin in coins_being_grabbed:
		if not is_instance_valid(coin):
			to_remove.append(coin)
		else:
			var desired_lv = coin.global_position.direction_to(global_position) * 640
			var actual_lv = coin.linear_velocity
			var lv_diff : Vector2 = desired_lv - actual_lv
			coin.apply_central_impulse(lv_diff.clamped(acceleration * delta))
	
	for bad_coin in to_remove:
		coins_being_grabbed.erase(bad_coin)
	
	$label.text = "grabbin %d coins" % coins_being_grabbed.size()

func _on_body_entered(body):
	if not active:
		return
	
	if body is Coin:
		coins_being_grabbed.append(body)
		body.slipperoni()
		var grabber = grab_scene.instance()
		grabber.target = body
		add_child(grabber)
		
		yield(get_tree().create_timer(1), "timeout")
		if is_instance_valid(body):
			body.double_slipperoni()
		


