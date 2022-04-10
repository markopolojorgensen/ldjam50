extends Node
class_name AudioFader

var tween := Tween.new()
var timer := Timer.new()

var from_track
var fade_started = false

var tween_end_position

func fade_track(to : AudioStreamPlayer, fade_in : bool):
	assert(to != null)
	
	add_child(tween)
	add_child(timer)
	
	to.play()
	
	tween.stop_all()
	tween.remove_all()
	tween_end_position = 1.0
	if fade_in:
		tween.interpolate_property(to, "volume_db", -80, 0, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	else:
		tween.interpolate_property(to, "volume_db", to.volume_db, -80, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()
	
	fade_started = true


func crossfade(from : AudioStreamPlayer, to : AudioStreamPlayer):
	assert(from != null)
	assert(to != null)
	
	if from == to:
		queue_free()
		return
	
	add_child(tween)
	add_child(timer)
	
	from_track = from
	
	to.play()
	
	tween.stop_all()
	tween.remove_all()
	tween_end_position = 2.0
	tween.interpolate_property(from, "volume_db", from.volume_db, -80, 2.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(to, "volume_db", to.volume_db, 0, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.start()
	
	fade_started = true

func finish_now():
	tween.seek(tween_end_position)
	queue_free()

# do this instead of yielding
# so that if this fade gets cancelled the yield doesn't complain
func _process(_delta):
	if fade_started and timer.is_stopped():
		from_track.stop()
		queue_free()






