extends Node2D

var low_pass_filter : AudioEffectLowPassFilter
const low_pass_min_cutoff = 8000
const low_pass_max_cutoff = 20500
const low_pass_max_reso = 0.6
const low_pass_min_reso = 0.2
const tween_duration = 2

var about_to_activate_tween = false

var music_bus_index
var effects_bus_index
var fanfares_bus_index


func _enter_tree():
	if $player_proximity_detector.is_player_near():
		call_deferred("start_rain", null)
	else:
		call_deferred("stop_rain", null)

func _ready():
	$player_proximity_detector.connect("body_entered", self, "start_rain")
	$player_proximity_detector.connect("body_exited", self, "stop_rain")
	$tween.connect("tween_all_completed", self, "tween_finished")
	
	$rain_sfx.play()
	
	
	music_bus_index = AudioServer.get_bus_index("Music")
	effects_bus_index = AudioServer.get_bus_index("Effects")
	fanfares_bus_index = AudioServer.get_bus_index("Fanfares")
	
	var nonrain_index = AudioServer.get_bus_index("NonRain")
	low_pass_filter = AudioServer.get_bus_effect(nonrain_index, 0)

func tween_finished():
	if about_to_activate_tween:
		return
	
	if $player_proximity_detector.is_player_near():
		pass
	else:
		AudioServer.set_bus_send(music_bus_index, "Master")
		AudioServer.set_bus_send(effects_bus_index, "Master")
		AudioServer.set_bus_send(fanfares_bus_index, "Master")

func start_rain(_body):
	if not $tween.is_inside_tree():
		print("rain sfx manager not inside tree")
		return
	
	about_to_activate_tween = true
	AudioServer.set_bus_send(music_bus_index, "NonRain")
	AudioServer.set_bus_send(effects_bus_index, "NonRain")
	AudioServer.set_bus_send(fanfares_bus_index, "NonRain")
	$tween.stop_all()
	$tween.remove_all()
	$tween.interpolate_property($rain_sfx, "volume_db", $rain_sfx.volume_db, -6, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(low_pass_filter, "cutoff_hz", low_pass_filter.cutoff_hz, low_pass_min_cutoff, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(low_pass_filter, "resonance", low_pass_filter.resonance, low_pass_min_reso, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()
	about_to_activate_tween = false
	

func stop_rain(_body):
	if not $tween.is_inside_tree():
		print("rain sfx manager not inside tree")
		return
	
	about_to_activate_tween = true
	$tween.stop_all()
	$tween.remove_all()
	$tween.interpolate_property($rain_sfx, "volume_db", $rain_sfx.volume_db, -80, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(low_pass_filter, "cutoff_hz", low_pass_filter.cutoff_hz, low_pass_max_cutoff, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.interpolate_property(low_pass_filter, "resonance", low_pass_filter.resonance, low_pass_max_reso, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$tween.start()
	about_to_activate_tween = false


