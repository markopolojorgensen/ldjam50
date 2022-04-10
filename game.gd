extends Node

export(bool) var start_muted = false
export(bool) var unlock_all_decorations = false


signal beat

const cycle_scene = preload("cycle/cycle.tscn")
var current_cycle

const end_screen_scene = preload("end_screen.tscn")

# used by disco ball to decide beat rate
# used to decide current beat count
var bpm_track
var bpms = {
	"safehouse": 62,
	"on_the_clock": 120,
	"empty_rumble": 5,
}
onready var music_tracks = [$safehouse, $on_the_clock, $empty_rumble]
var beat_count = 0
# used to notice when music has looped
var previous_playback_position = 0
# used to decide which track to fade to when player buys music
var in_base = false



func _ready():
	add_to_group("store_listeners")
	add_to_group("win")
	global.music = self
	global.game = self
	
	$music_fade_timer.connect("timeout", self, "post_fade")
	
	create_new_cycle()
	
	if start_muted:
		toggle_mute()
	
	if unlock_all_decorations:
		global.items_purchased = [
			"music",
			"balloons",
			"bundles",
			"hats",
			"bunting",
			"streamers",
			"banners",
			"disco balls",
#			"",
#			"",
		]
	
	call_deferred("leave_base")

func cycle_ended():
	print("resetting cycle")
	$cycle_reset_animation_player.play("reset")

func create_new_cycle():
	if is_instance_valid(current_cycle):
		current_cycle.queue_free()
	current_cycle = cycle_scene.instance()
	global.current_cycle = current_cycle
	add_child(current_cycle)
	current_cycle.connect("cycle_ended", self, "cycle_ended")

func _unhandled_input(event):
	if event.is_action_pressed("instaquit"):
		get_tree().set_input_as_handled()
		get_tree().quit()
	elif event.is_action_pressed("toggle_fullscreen"):
		get_tree().set_input_as_handled()
		OS.window_fullscreen = not OS.window_fullscreen
	elif event.is_action_pressed("toggle_mute"):
		get_tree().set_input_as_handled()
		toggle_mute()

func toggle_mute():
	var music_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_index, not AudioServer.is_bus_mute(music_index))

func enter_base():
	in_base = true
	if "music" in global.items_purchased:
		crossfade($safehouse)
	else:
		crossfade($empty_rumble)

func leave_base():
	in_base = false
	if "music" in global.items_purchased:
		crossfade($on_the_clock)
	else:
		crossfade($empty_rumble)

func bought_item():
	if in_base:
		enter_base()
	else:
		leave_base()

# from can be null
func crossfade(to : AudioStreamPlayer):
	# is there a track currently playing?
	# is there already a fade happening?
	
	if not to.playing:
		to.play(30)
	bpm_track = to
	update_beat_count(true)
	
	$music_tween.stop_all()
	$music_tween.remove_all()
	for track in music_tracks:
		if track == to:
			$music_tween.interpolate_property(track, "volume_db", track.volume_db, 0, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		else:
			$music_tween.interpolate_property(track, "volume_db", track.volume_db, -80, 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$music_tween.start()
	
	$music_fade_timer.start()

func post_fade():
	for track in music_tracks:
		if track != bpm_track:
			track.stop()

func _process(_delta):
	update_beat_count()

# hard reset when switching tracks to update beat count without emitting extra beats
func update_beat_count(hard_reset = false):
	if bpm_track == null:
		return
	
	var playback_position = (bpm_track as AudioStreamPlayer).get_playback_position()
	# did we loop?
	if playback_position < previous_playback_position:
		hard_reset = true
#		print(playback_position)
		if playback_position < 0.1: # less than a tenth of a second after the song loops
			emit_signal("beat")
	var bpm = bpms[bpm_track.name]
	var beats_per_second = bpm / 60.0
	var beats_so_far = int(floor(playback_position * beats_per_second))
	if hard_reset:
		beat_count = beats_so_far
	elif beat_count < beats_so_far:
		# print("updating beat count | playback: %.1f seconds | bpm: %d | bps: %.1f | beats_so_far: %d |" % [playback_position, bpm, beats_per_second, beats_so_far])
		# print("beat")
		emit_signal("beat")
		beat_count = beats_so_far
	previous_playback_position = playback_position

func on_win():
	var end_screen = end_screen_scene.instance()
	add_child(end_screen)

func get_bpm():
	return bpms[bpm_track.name]

































